json.pagination do
  json.next_page items.next_page
  json.current_page items.current_page
  json.total_entries items.total_entries
  json.total_pages items.total_pages
end