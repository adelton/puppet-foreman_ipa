# Manage your foreman IPA integration
#
# === Parameters:
#
# $keytab::          Kerberos keytab file
# $pam_service::     PAM service to use/configure
#
class foreman_ipa ( 
  $keytab = $foreman_ipa::params::keytab,
  $pam_service = $foreman_ipa::params::pam_service,
) inherits foreman_ipa::params {

  class { 'foreman_ipa::install': } ~>
  class { 'foreman_ipa::config': } ~>
  # class { 'foreman_ipa::service: }
  Class['foreman_ipa']

}
# $user::            Desired user name
