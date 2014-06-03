$ ->

  # login page
  
  remember_cb = $('.login-form .checkbox-wrap')
  checkbox_input = remember_cb.find('input')

  remember_cb.on 'click', (e) ->
    checked = checkbox_input.val()|0
    if checked
      remember_cb.removeClass('is-selected')
      checkbox_input.val(0)
    else
      remember_cb.addClass('is-selected')
      checkbox_input.val(1)