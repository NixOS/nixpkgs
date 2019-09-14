source $stdenv/setup

buildPhase() {
  mvn package
}

# okta-aws-cli-assume-role repository doesn't have any of the scripts that
# should be put in bin/. There is a install.sh script that creates them but
# it also downloads a pre-compiled jar that we previously built from source.
# Instead I copied the script creation steps from install.sh and run that in
# installPhase.
installPhase() {
  mkdir -p $out/bin
  mkdir -p $out/share

  # Install compiled JAR file
  cp ./target/okta-aws-cli-$version.jar $out/share/
  ln -s okta-aws-cli-$version.jar $out/share/okta-aws-cli.jar

  # Create bash functions
  bash_functions="$out/bash_functions"
  cat <<EOF >>"${bash_functions}"
#OktaAWSCLI
function okta-aws {
    $out/bin/withokta "aws --profile \$1" "\$@"
}
EOF
  
  # Create fish shell functions
  fishFunctionsDir="$out/fish_functions"
  mkdir -p "${fishFunctionsDir}"
  cat <<EOF >"${fishFunctionsDir}/okta-aws.fish"
function okta-aws
    $out/bin/withokta "aws --profile \$argv[1]" \$argv
end
EOF

  # Suppress "Your profile name includes a 'profile ' prefix" warnings
  # from AWS Java SDK (Resolves https://github.com/oktadeveloper/okta-aws-cli-assume-role/issues/233)
  loggingProperties="$out/logging.properties"
  cat <<EOF >"${loggingProperties}"
com.amazonaws.auth.profile.internal.BasicProfileConfigLoader = NONE
EOF

  # Create withokta command
  cat <<EOF >"$out/bin/withokta"
#!/bin/bash
export PATH=@jre@/bin:@awscli@/bin:\$PATH
command="\$1"
profile=\$2
shift;
shift;
if [ "\$3" == "logout" ]
then
    command="logout"
fi
env OKTA_PROFILE=\$profile java \
    -Djava.util.logging.config.file=$out/logging.properties \
    -classpath $out/share/okta-aws-cli.jar \
    com.okta.tools.WithOkta \$command "\$@"
EOF
  chmod +x "$out/bin/withokta"

  # Create okta-credential_process command
  cat <<EOF >"$out/bin/okta-credential_process"
#!/bin/bash
export PATH=@jre@/bin:@awscli@/bin:\$PATH
roleARN="\$1"
shift;
env OKTA_AWS_ROLE_TO_ASSUME="\$roleARN" \
    java -classpath $out/share/okta-aws-cli.jar com.okta.tools.CredentialProcess
EOF
  chmod +x "$out/bin/okta-credential_process"

  # Create okta-listroles command
  cat <<EOF >"$out/bin/okta-listroles"
#!/bin/bash
export PATH=@jre@/bin:@awscli@/bin:\$PATH
java -classpath $out/share/okta-aws-cli.jar com.okta.tools.ListRoles
EOF
  chmod +x "$out/bin/okta-listroles"

  # awscli
  cat <<EOF >"$out/bin/awscli"
#!/bin/bash
export PATH=@jre@/bin:@awscli@/bin:\$PATH
$out/bin/withokta aws default "$@"
EOF
  chmod +x "$out/bin/awscli"

  # Run postInstall hook
  runHook postInstall
}

genericBuild
