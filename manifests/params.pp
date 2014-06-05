# The foreman default parameters
class foreman_ipa::params {
  $admin = 'admin'
  $keytab = "/etc/httpd/conf/http.keytab"
  $pam_service = 'foreman'
}
