json.meetings @meetings do |meeting|
  json.id meeting.id
  json.started_at  meeting.started_at.to_i
  json.started_at_time  meeting.started_at_time
  json.started_at_date  meeting.started_at_date
  json.name meeting.name
  json.klass meeting.started_at < Time.zone.now ? 'is-running' : ''
  json.start_time meeting.started_at.strftime('%d %B %I:%M %P')
  json.url "#{request.protocol}#{request.host_with_port}/meetings/#{meeting.id}"
end

json.partial! 'api/shared/pagination', items: @meetings