{ pkgs, ... }:

with pkgs;

{
  nodes = {
    one =
      { config, pkgs, ... }: {
        services.avahi.enable = true;
        services.avahi.nssmdns = true;
      };

    two =
      { config, pkgs, ... }: {
        services.avahi.enable = true;
        services.avahi.nssmdns = true;
      };
  };

  # Test whether `avahi-daemon' and `libnss-mdns' work as expected.
  testScript =
    '' startAll;

       # mDNS.
       $one->waitForJob("network.target");
       $one->mustSucceed("avahi-resolve-host-name one.local | tee out >&2");
       $one->mustSucceed("test \"`cut -f1 < out`\" = one.local");
       $one->mustSucceed("avahi-resolve-host-name two.local | tee out >&2");
       $one->mustSucceed("test \"`cut -f1 < out`\" = two.local");

       $two->waitForJob("network.target");
       $two->mustSucceed("avahi-resolve-host-name one.local | tee out >&2");
       $two->mustSucceed("test \"`cut -f1 < out`\" = one.local");
       $two->mustSucceed("avahi-resolve-host-name two.local | tee out >&2");
       $two->mustSucceed("test \"`cut -f1 < out`\" = two.local");

       # Basic DNS-SD.
       $one->mustSucceed("avahi-browse -r -t _workstation._tcp | tee out >&2");
       $one->mustSucceed("test `wc -l < out` -gt 0");
       $two->mustSucceed("avahi-browse -r -t _workstation._tcp | tee out >&2");
       $two->mustSucceed("test `wc -l < out` -gt 0");

       # More DNS-SD.
       $one->execute("avahi-publish -s \"This is a test\" _test._tcp 123 one=1 &");
       $one->sleep(5);
       $two->mustSucceed("avahi-browse -r -t _test._tcp | tee out >&2");
       $two->mustSucceed("test `wc -l < out` -gt 0");

       # NSS-mDNS.
       $one->mustSucceed("getent hosts one.local >&2");
       $one->mustSucceed("getent hosts two.local >&2");
       $two->mustSucceed("getent hosts one.local >&2");
       $two->mustSucceed("getent hosts two.local >&2");
    '';
}
