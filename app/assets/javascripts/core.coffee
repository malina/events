window.Sorting = 
  current_sorting_type: 'name',

  sort: (type, list) ->
    tmp_users_list = _.sortBy(list,(obj) -> obj[type])
    if (@current_sorting_type != type )
      @current_sorting_type = type
    else if(@current_sorting_type == type)
      tmp_users_list = tmp_users_list.reverse()
      @current_sorting_type = null
    return tmp_users_list