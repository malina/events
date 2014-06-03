$ ->
  leftbar = $('.leftbar')
  overw = $('.overlay.light')
  overd = $('.overlay.dark')
  over_cont= $('.overlay-dark-container')
  list = $('.meetings-list ul')

  popup_info = $('.show-meeting')
  popup_info_list = $('.show_meeting_list ul')

  popup_users = $('.select_users_popup')
  popup_users_list = $('.select_users_popup .users-list ul')



  current_page = 1
  users_page = 1

  show_leftbar  = ->
    overw.removeClass('is-hidden')
    leftbar.animate({left: "-50%", "margin-left":"80px"},500)

  hide_leftbar = ->
    overw.addClass('is-hidden')
    leftbar.animate({left: "-100%", "margin-left":"-560px"},500)


  show_popup  = (popup) ->
    overd.removeClass('is-hidden')
    over_cont.removeClass('is-hidden')
    over_cont.append(popup)
    popup.removeClass('is-hidden')
    popup.addClass('is-popup')
    $('body').addClass('is-overlayed')
    
  hide_popup = (popup) ->
    popup.addClass('is-hidden')
    over_cont.addClass('is-hidden')
    overd.addClass('is-hidden')
    popup.removeClass('is-popup')
    $('.popups-container').append(popup)
    $('body').removeClass('is-overlayed')
    

  toggle_list_select = (item) ->
    if item.hasClass('is-selected')
      item.removeClass 'is-selected'
      $('.main .list-header .actions .buttons').animate({top: "30px"},500)
    else
      list.find('.item').removeClass 'is-selected'
      item.addClass 'is-selected'
      $('.main .list-header .actions .buttons').animate({top: "0"},500)



  load_meetings = ->
    return if current_page == 0
    $.ajax(url: '/api/meetings.json', type: "GET", dataType: "json", data: {page: current_page, per_page: 300}, success: (data) ->
      list.append(JST['templates/meetings/meeting_item'](m)) for m in data.meetings
      
      list.find('.meeting-title .link').on 'click', (e) ->
          show_meeting_info $(e.target).data('id')
          return

      current_page+=1
      if data.pagination.total_pages == current_page-1
        $('.main .load-more .link').hide()
        current_page = 0 
      )


  reload_meetings = ->
    current_page = 1
    $('.main .load-more .link').show()
    list.empty()
    load_meetings()

  delete_meeting = (id) ->
    $.ajax(url: "/api/meetings/#{id}.json", type: "DELETE", data: {authenticity_token: AUTH_TOKEN}, dataType: "json", success: (data) ->
      reload_meetings()      
    )

  show_meeting_info = (id) ->
    $.ajax(url: "/api/meetings/#{id}.json", type: "GET", dataType: "json", success: (data) ->
      
      popup_info.find("textarea[name=meeting_name]").val(data.meeting.name)
      popup_info.find("input[name=meeting_start_time]").val(data.meeting.start_time)
      popup_info.find("input[name=meeting_url]").val(data.meeting.url)

      popup_info_list.append(JST['templates/meetings/show_participant_item'](p)) for p in data.participants

      show_popup(popup_info)

      overd.one 'click', -> hide_popup(popup_info)
      )

  select_users = ->
    return if users_page == 0
    $.ajax(url: '/api/users.json', type: "GET", dataType: "json", data: {page: users_page, per_page: 300}, success: (data) ->
      popup_users_list.append(JST['templates/users/select_user_item'](u)) for u in data.users
      
      users_page+=1
      if data.pagination.total_pages == users_page-1
        $('.select_users_popup .load-more .link').hide()
        users_page = 0 
      )

  $('.leftbar .add-users-btn').on 'click', ->
    popup_users_list.empty()
    $('.select_users_popup .load-more .link').show()
    users_page=1
    select_users()
    show_popup popup_users
    overd.one 'click', -> hide_popup(popup_users)

  $('.main .del-btn').on 'click', ->
    id = list.find('.item.is-selected .link').data('id')
    delete_meeting(id) if id
    return

  $('.main .edit-btn').on 'click', ->
    confirm('pending')
    return

  $('.main .sidebar .create-btn').on 'click', ->
    show_leftbar()
    overw.one 'click', hide_leftbar
    $('.leftbar .cancel-btn').one 'click', hide_leftbar

  list.on 'click', '.item', (e) ->
    toggle_list_select($(e.currentTarget))
    return

  $('.main .load-more .link').on 'click', (e) ->
    load_meetings()
    return

  $('.select_users_popup .load-more .link').on 'click', (e) ->
    select_users()
    return

  load_meetings()