json.users @users do |user|
  json.partial! 'api/users/user', item: user
end

json.partial! 'api/shared/pagination', items: @users