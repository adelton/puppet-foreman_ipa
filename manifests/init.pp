# = Manage your foreman IPA integration
#
# It expects that you host is enrolled in IPA and you currently have
# ticket for admin user.
#
# === Parameters:
#
# $keytab::          Kerberos keytab file
#
# $pam_service::     PAM service to use/configure
#
# $custom_repo::     Should we add custom repo to install several related
#                    packages? If you have your own provider, you can say
#                    false here. Otherwise (usually CentOS and Fedora) answer
#                    true
#                    type:boolean
#
class foreman_ipa ( 
  $keytab      = $foreman_ipa::params::keytab,
  $pam_service = $foreman_ipa::params::pam_service,
  $custom_repo = $foreman_ipa::params::custom_repo,
) inherits foreman_ipa::params {

  class { 'foreman_ipa::install': } ~>
  class { 'foreman_ipa::config': } ~>
  Class['foreman_ipa']

}
