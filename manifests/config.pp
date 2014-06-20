class foreman_ipa::config {

  selboolean { 'allow_httpd_mod_auth_pam':
    persistent => true,
    value      => 'on',
  }

  exec { 'setsebool httpd_dbus_sssd':
    command => "/usr/sbin/setsebool -P httpd_dbus_sssd on",
    onlyif  => "/usr/sbin/getsebool httpd_dbus_sssd",
    unless  => "/usr/sbin/getsebool httpd_dbus_sssd | grep 'on$'",
  }

  exec { 'setenforce permissive':
    command => "/usr/sbin/setenforce 0",
    unless  => "/usr/sbin/getsebool httpd_dbus_sssd || /usr/sbin/getenforce | grep 'Permissive'",
  }


  service { 'sssd':
    ensure  => running,
    enable  => true,
    require => Package['sssd-dbus'],
  }


  file { "/etc/pam.d/$foreman_ipa::pam_service":
    owner   => root,
    group   => root,
    mode    => 644,
    content => template('foreman_ipa/pam_service.erb'),
  }

  exec { 'ipa-getkeytab':
    command => "/usr/sbin/ipa-getkeytab -s ${::default_ipa_server} -k $foreman_ipa::keytab -p HTTP/${::fqdn}",
    creates => $foreman_ipa::keytab,
    before  => File[$foreman_ipa::keytab],
  }

  file { $foreman_ipa::keytab:
    owner => apache,
    mode  => 600,
    ensure => file,
  }

  file { '/etc/httpd/conf.d/intercept_form_submit.conf':
    content => template('foreman_ipa/intercept_form_submit.conf.erb'),
  }

  file { '/etc/httpd/conf.d/lookup_identity.conf':
    content => template('foreman_ipa/lookup_identity.conf.erb'),
  }

  file { '/etc/httpd/conf.d/auth_kerb.conf':
    content => template('foreman_ipa/auth_kerb.conf.erb'),
  }


  $sssd_services = $sssd_services ? {
    /\bifp\b/ => $sssd_services,
    ''        => 'ifp',
    default   => "$sssd_services, ifp"
  }


  $sssd_ldap_user_extra_attrs = $sssd_ldap_user_extra_attrs ? {
    /\bemail:mail\b/ => $sssd_ldap_user_extra_attrs,
    ''               => 'email:mail',
    default          => "$sssd_ldap_user_extra_attrs, email:mail",
  }

  $sssd_ldap_user_extra_attrs2 = $sssd_ldap_user_extra_attrs ? {
    /\blastname:sn\b/ => $sssd_ldap_user_extra_attrs,
    default           => "$sssd_ldap_user_extra_attrs, lastname:sn",
  }

  $sssd_ldap_user_extra_attrs3 = $sssd_ldap_user_extra_attrs2 ? {
    /\bfirstname:givenname\b/ => $sssd_ldap_user_extra_attrs2,
    default                   => "$sssd_ldap_user_extra_attrs2, firstname:givenname",
  }


  $sssd_allowed_uids = $sssd_allowed_uids ? {
    /\bapache\b/ => $sssd_allowed_uids,
    ''           => 'apache',
    default      => "$sssd_allowed_uids, apache",
  }
  $sssd_allowed_uids2 = $sssd_allowed_uids ? {
    /\broot\b/ => $sssd_allowed_uids,
    default    => "$sssd_allowed_uids, root",
  }


  $sssd_user_attributes = $sssd_user_attributes ? {
    /\+email\b/ => $sssd_user_attributes,
    ''          => '+email',
    default     => "$sssd_user_attributes, +email",
  }

  $sssd_user_attributes2 = $sssd_user_attributes ? {
    /\+firstname\b/ => $sssd_user_attributes,
    default         => "$sssd_user_attributes, +firstname",
  }

  $sssd_user_attributes3 = $sssd_user_attributes2 ? {
    /\+lastname\b/ => $sssd_user_attributes2,
    default        => "$sssd_user_attributes2, +lastname",
  }


  augeas { 'sssd-ifp-extra-attributes':
    context => '/files/etc/sssd/sssd.conf',
    changes => [
      "set target[.=~regexp('domain/.*')]/ldap_user_extra_attrs '$sssd_ldap_user_extra_attrs3'",
      "set target[.='sssd']/services '$sssd_services'",
      "set target[.='ifp'] 'ifp'",
      "set target[.='ifp']/allowed_uids '$sssd_allowed_uids2'",
      "set target[.='ifp']/user_attributes '$sssd_user_attributes3'",
    ],
    notify => Service['sssd'],
  }

  concat_fragment {'foreman_settings+02-authorize_login_delegation.yaml':
    content => template('foreman_ipa/settings.yaml.erb'),
  }
}
