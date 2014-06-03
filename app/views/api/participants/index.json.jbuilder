json.users @users do |user|
  json.partial! 'api/shared/participant', user: user
end