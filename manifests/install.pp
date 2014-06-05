class foreman_ipa::install {
  yumrepo { 'adelton-identity':
    # enabled => 0,
    enabled => 1,
    gpgcheck => 0,
    baseurl => 'http://copr-be.cloud.fedoraproject.org/results/adelton/identity_demo/epel-6-$basearch/',
  }

  package { 'mod_auth_kerb':
    ensure => installed,
  }
  package { [ 'mod_authnz_pam', 'mod_lookup_identity', 'mod_intercept_form_submit', 'sssd-dbus' ]:
    ensure => installed,
    # install_options => [ "--enablerepo", "adelton-identity" ],
    require => Yumrepo["adelton-identity"],
  }
}
