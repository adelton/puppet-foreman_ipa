class foreman_ipa::install {
  if $custom_repo {
    yumrepo { 'adelton-identity':
      enabled  => 1,
      gpgcheck => 0,
      baseurl  => 'http://copr-be.cloud.fedoraproject.org/results/adelton/identity_demo/epel-6-$basearch/',
      before   => [ Package['mod_authnz_pam'], Package['mod_lookup_identity'], Package['mod_intercept_form_submit'], Package['sssd-dbus'] ],
    }
  }

  package { 'mod_auth_kerb':
    ensure => installed,
  }

  # these packages can be obtained from adelton-identity yum repo
  package { [ 'mod_authnz_pam', 'mod_lookup_identity', 'mod_intercept_form_submit', 'sssd-dbus' ]:
    ensure  => installed,
  }
}
