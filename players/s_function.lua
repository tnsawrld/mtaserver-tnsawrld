local Minimum_Password_Lenght = 6

function isInvalidPassword(password)
  return string.len(password) >= Minimum_Password_Lenght
end