module ApiSpecHelpers
  def pagination(current, total_entries = 0, total_pages = 1, nxt = 'null')
    %({"current_page":#{current},"next_page":#{nxt},"total_entries":#{total_entries},"total_pages":#{total_pages}})
  end
end