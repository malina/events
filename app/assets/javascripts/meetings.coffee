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

  meetings_list = []


  current_page = 1
  users_page = 1

  editable_meeting = {}
  current_meeting = {}

  added_users = []

  show_leftbar  = () ->
    overw.removeClass('is-hidden')

    added_users = []

    leftbar.find('.meeting-form').empty()
    leftbar.find('.meeting-form').append(JST['templates/meetings/meeting_form'](current_meeting.meeting))
    leftbar.find('.content .list').empty()
    if current_meeting.participants
      leftbar.find('.content .list').append(JST['templates/meetings/show_participant_item'](p)) for p in current_meeting.participants
    leftbar.css({left: "-50%", "margin-left":"80px"})

  hide_leftbar = ->
    overw.addClass('is-hidden')
    leftbar.css({left: "-100%", "margin-left":"-560px"})

  # нужно оставить анимацию в одном месте - либо в js, либо  в css. Я за css анимацию.


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
      $('.main .list-header .actions .buttons').css({top: "30px"})
      #$('.main .list-header .actions .buttons').animate({top: "30px"},500)
      # нужно оставить анимацию в одном месте - либо в js, либо  в css. Я за css анимацию.
    else
      list.find('.item').removeClass 'is-selected'
      item.addClass 'is-selected'
      $('.main .list-header .actions .buttons').css({top: "0"})



  load_meetings = ->
    return if current_page == 0
    $.ajax(url: '/api/meetings.json', type: "GET", dataType: "json", data: {page: current_page, per_page: 300}, success: (data) ->
      
      meetings_list = _.compact(_.union(meetings_list, data.meetings))
      list.append(JST['templates/meetings/meeting_item'](m)) for m in meetings_list

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
    show_leftbar()
    overw.one 'click', hide_leftbar
    $('.leftbar .cancel-btn').one 'click', hide_leftbar
    return

  $('.main .sidebar .create-btn').on 'click', ->
    show_leftbar()
    overw.one 'click', hide_leftbar
    $('.leftbar .cancel-btn').one 'click', hide_leftbar

  list.on 'click', '.item', (e) ->
    set_editable_meeting($(this).data('id'))
    toggle_list_select($(e.currentTarget))
    return

  $('.main .load-more .link').on 'click', (e) ->
    load_meetings()
    return

  $('.select_users_popup .load-more .link').on 'click', (e) ->
    select_users()
    return

  load_meetings()


  # ----------
  # Сортировка

  $('.main .heading').on 'click', (e) ->
    type = $(this).data('name')
    
    if (window.Sorting.current_sorting_type != type) 
      window.Sorting.current_sorting_type = null
    tmp_list = window.Sorting.sort(type, meetings_list)

    list.html('')
    list.append(JST['templates/meetings/meeting_item'](m)) for m in tmp_list

    return

  set_editable_meeting = (id) ->
    $.ajax(url: "/api/meetings/#{id}.json", type: "GET", dataType: "json", success: (data) ->
      current_meeting = data
    )




  $("body").on "click", ".users_select_list .item", ->
    id = $(this).data('id')
    added_users.push({id: id})
    console.log added_users

  $(".leftbar").on "click", ".button-save", ->
    meeting =
      name: $('.name-field-input').val()
      started_at_date: $('.date-field-input').val()
      started_at_time: $('.time-field-input').val()
    $.ajax(url: '/api/meetings', type: "POST", dataType: "json", data: {meeting: meeting, participants: added_users, authenticity_token: window.AUTH_TOKEN}, success: (data) ->

    )

    meeting = {}
    added_users = []

