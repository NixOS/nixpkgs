. $stdenv/setup


configureFlags="--with-privsep-path=$out/empty"
 
postInstall() {
   rm $out/etc/ssh_host_dsa_key $out/etc/ssh_host_dsa_key.pub $out/etc/ssh_host_key $out/etc/ssh_host_key.pub $out/etc/ssh_host_rsa_key $out/etc/ssh_host_rsa_key.pub

   chmod +r $out/libexec/ssh-keysign
}
#postInstall=postInstall

genericBuild
