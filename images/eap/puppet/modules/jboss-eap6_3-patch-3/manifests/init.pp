class jboss-eap6_3-patch-3 {
  exec { 'Patch JBoss EAP':
    cwd     => '/opt/jboss/jboss-eap-6.3.0',
    command => '/opt/jboss/jboss-eap-6.3.0/bin/jboss-cli.sh "patch apply /tmp/jboss-eap-6.3.3-patch.zip"',
    #unless  => '/opt/jboss/jboss-eap-6.3.0/bin/jboss-cli.sh "patch info" | grep cumulative-patch-id | grep eap-6.3.3',
    unless => '/opt/jboss/jboss-eap-6.3.0/bin/jboss-cli.sh "patch info" | grep cumulative-patch-id | cut -d \':\' -f 2 | sed "s/^ \"jboss-eap-//g" | sed "s/\.CP\",$//g" | sed "s/\.//g" | awk \'{ if ($1<633) { exit 1 } else { exit 0 }}\''
  }
}
