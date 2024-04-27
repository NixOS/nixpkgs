from ipaplatform.fedora.paths import FedoraPathNamespace

class NixOSPathNamespace(FedoraPathNamespace):
    SBIN_IPA_JOIN = "@out@/bin/ipa-join"
    IPA_GETCERT = "@out@/bin/ipa-getcert"
    IPA_RMKEYTAB = "@out@/bin/ipa-rmkeytab"
    IPA_GETKEYTAB = "@out@/bin/ipa-getkeytab"
    NSUPDATE = "@bind@/bin/nsupdate"
    BIN_CURL = "@curl@/bin/curl"
    KINIT = "@kerberos@/bin/kinit"
    KDESTROY = "@kerberos@/bin/kdestroy"

paths = NixOSPathNamespace()
