# Manage your foreman IPA integration
#
# === Parameters:
#
# $user::            Desired user name
#
class foreman_ipa ( 
  $user = $foreman_ipa::params::user,
) inherits foreman_ipa::params {

  # do something, like instantiate traditional classes
  # class { 'foreman_ipa::install': } ~>
  # class { 'foreman_ipa::config': } ~>
  # class { 'foreman_ipa::service: }
}
