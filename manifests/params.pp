# The foreman default parameters
class foreman_ipa::params {
  $keytab      = "/etc/httpd/conf/http.keytab"
  $pam_service = 'foreman'
  $custom_repo = true
}
