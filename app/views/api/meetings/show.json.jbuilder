json.meeting do
  json.id @meeting.id 
  json.started_at_utc @meeting.started_at.to_i
  json.name @meeting.name
  json.start_time @meeting.started_at.strftime('%d %B %I:%M %P')
  json.url "#{request.protocol}#{request.host_with_port}/meetings/#{@meeting.id}"
end

json.participants @users do |user|
  json.partial! 'api/shared/participant', user: user
end