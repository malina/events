$ ->
  nod = $('.main-progress')
  return unless nod[0]
  nod.css({width: '100%'})
  setTimeout((->
    nod.css({opacity: 0})
    setTimeout( (-> nod.remove()), 500)), 
  500)
