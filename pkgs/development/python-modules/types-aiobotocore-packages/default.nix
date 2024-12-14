{
  lib,
  stdenv,
  aiobotocore,
  boto3,
  botocore,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

let
  toUnderscore = str: builtins.replaceStrings [ "-" ] [ "_" ] str;
  buildTypesAiobotocorePackage =
    serviceName: version: hash:
    buildPythonPackage rec {
      pname = "types-aiobotocore-${serviceName}";
      inherit version;
      pyproject = true;

      disabled = pythonOlder "3.7";

      oldStylePackages = [
        "gamesparks"
        "iot-roborunner"
        "macie"
      ];

      src = fetchPypi {
        pname =
          if builtins.elem serviceName oldStylePackages then
            "types-aiobotocore-${serviceName}"
          else
            "types_aiobotocore_${toUnderscore serviceName}";
        inherit version hash;
      };

      build-system = [ setuptools ];

      dependencies = [
        aiobotocore
        boto3
        botocore
      ] ++ lib.optionals (pythonOlder "3.12") [ typing-extensions ];

      # Module has no tests
      doCheck = false;

      pythonImportsCheck = [ "types_aiobotocore_${toUnderscore serviceName}" ];

      meta = with lib; {
        description = "Type annotations for aiobotocore ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = licenses.mit;
        maintainers = with maintainers; [ mbalatsko ];
      };
    };
in
rec {
  types-aiobotocore-accessanalyzer =
    buildTypesAiobotocorePackage "accessanalyzer" "2.15.2"
      "sha256-phl4/2H/Eca6fAEMRwF243B2tuzXYOofiWCFBmX8zAk=";

  types-aiobotocore-account =
    buildTypesAiobotocorePackage "account" "2.15.2"
      "sha256-k66NAKboMyLeFnpnsDTY6i2BP7GRRWgALmva/JRtOzo=";

  types-aiobotocore-acm =
    buildTypesAiobotocorePackage "acm" "2.15.2"
      "sha256-eLo4G5qHs9BxcuYxJUszMHxSFegzAiMmsFZO1DdVnQk=";

  types-aiobotocore-acm-pca =
    buildTypesAiobotocorePackage "acm-pca" "2.15.2"
      "sha256-Q2LW9rHXP78eKyfNN9b7c7YDeM/f/GnzbeGZJ4TDWGA=";

  types-aiobotocore-alexaforbusiness =
    buildTypesAiobotocorePackage "alexaforbusiness" "2.13.0"
      "sha256-+w/InoQR2aZ5prieGhgEEp7auBiSSghG5zIIHY5Kyao=";

  types-aiobotocore-amp =
    buildTypesAiobotocorePackage "amp" "2.15.2"
      "sha256-Qit4RmUHdSIcbOEQOsSZW6ARdx/S/b9qpfJxgMCP6uM=";

  types-aiobotocore-amplify =
    buildTypesAiobotocorePackage "amplify" "2.15.2"
      "sha256-Omrz8qlW74Yv69ElHjCpab0X4PAQ9vWc/L9JIyM6uwk=";

  types-aiobotocore-amplifybackend =
    buildTypesAiobotocorePackage "amplifybackend" "2.15.2"
      "sha256-amNBmVDOA6sIEWU0K/wpQWh9q1QzNLpuqf7vEzRvouE=";

  types-aiobotocore-amplifyuibuilder =
    buildTypesAiobotocorePackage "amplifyuibuilder" "2.15.2"
      "sha256-uCh6W8IWBmDIYCxqdbt5PBmd/iId5u5GGUG9tjL7W2w=";

  types-aiobotocore-apigateway =
    buildTypesAiobotocorePackage "apigateway" "2.15.2"
      "sha256-+8fuio9+dP2IqQJn+t2dshAdNyayQypdQNjefhDhRjo=";

  types-aiobotocore-apigatewaymanagementapi =
    buildTypesAiobotocorePackage "apigatewaymanagementapi" "2.15.2"
      "sha256-Z/ib8krZwZ03DoQS/zyB6jKet0+gmTBkOHUew/i0A+4=";

  types-aiobotocore-apigatewayv2 =
    buildTypesAiobotocorePackage "apigatewayv2" "2.15.2"
      "sha256-6Y8A/y30axUzYREdgLWH92gIG4pWvNkWKOxoTfYRQVw=";

  types-aiobotocore-appconfig =
    buildTypesAiobotocorePackage "appconfig" "2.15.2"
      "sha256-I8fTll4jIngD0UHqRx4WhM+WPXuvepHvXByYlgHSrDE=";

  types-aiobotocore-appconfigdata =
    buildTypesAiobotocorePackage "appconfigdata" "2.15.2"
      "sha256-KfmKk/d1ZXcGeYvzqlJh43uHiQvsXzbyytybvEUcVbI=";

  types-aiobotocore-appfabric =
    buildTypesAiobotocorePackage "appfabric" "2.15.2"
      "sha256-+BNkaM4f+DRqiSmY0uHksGTTbU7pBuJt+y8S2GRUkdg=";

  types-aiobotocore-appflow =
    buildTypesAiobotocorePackage "appflow" "2.15.2"
      "sha256-aVprs4EiYNo4+VdzQAPE8/UYMebQDYDcTjEBGAN+PdQ=";

  types-aiobotocore-appintegrations =
    buildTypesAiobotocorePackage "appintegrations" "2.15.2"
      "sha256-BbhuY9g4oUnBBhoo75bVpNZRWeGDYCl5kwKlW7X3Ek0=";

  types-aiobotocore-application-autoscaling =
    buildTypesAiobotocorePackage "application-autoscaling" "2.15.2"
      "sha256-ggg7zdytM3/Gz5mTQCFCHG8NVfj+q79Wt0B/LEgSfvA=";

  types-aiobotocore-application-insights =
    buildTypesAiobotocorePackage "application-insights" "2.15.2"
      "sha256-uGVDVNNBV7vzhsBStrEGq4EKvhp/pbcS00becWLM35E=";

  types-aiobotocore-applicationcostprofiler =
    buildTypesAiobotocorePackage "applicationcostprofiler" "2.15.2"
      "sha256-FvfKD+vSV4jYk62NFDqHwXNaScqQL7uxv9QhnJ5zNEI=";

  types-aiobotocore-appmesh =
    buildTypesAiobotocorePackage "appmesh" "2.15.2"
      "sha256-t96fm5t8s6XeeyUcAF93aVdU+Zu9flGKTQBtR0wsQ1Y=";

  types-aiobotocore-apprunner =
    buildTypesAiobotocorePackage "apprunner" "2.15.2"
      "sha256-irCvrU+nnmWTvP+r4kVnSTz8QEFJvPCJ9MKXECikMgs=";

  types-aiobotocore-appstream =
    buildTypesAiobotocorePackage "appstream" "2.15.2"
      "sha256-iGmu1EKY9YXFIzLqoya+oTc0CjGw4zoKdnmZG5OTYX0=";

  types-aiobotocore-appsync =
    buildTypesAiobotocorePackage "appsync" "2.15.2"
      "sha256-82XUaNGcXO6P9w1ai0yg788yn3eTZ5G5+U1CiIEMvhQ=";

  types-aiobotocore-arc-zonal-shift =
    buildTypesAiobotocorePackage "arc-zonal-shift" "2.15.2"
      "sha256-h96kwgdTwldKgyBxy/K2nO0eRp+dsx/Zms9ZJm2jgoA=";

  types-aiobotocore-athena =
    buildTypesAiobotocorePackage "athena" "2.15.2"
      "sha256-L6dfltBPK+6TBs5bfrQtYoaXEzTp4h7Z1YGpThrU2mU=";

  types-aiobotocore-auditmanager =
    buildTypesAiobotocorePackage "auditmanager" "2.15.2"
      "sha256-zaO6TuUySzlKPc5SizuSFtK25LjCQCyDF/oUcfYSb9Q=";

  types-aiobotocore-autoscaling =
    buildTypesAiobotocorePackage "autoscaling" "2.15.2"
      "sha256-L/EIaJrRPfNzwOEeJaR+E4c1niLpjBcnFYsWxcyfnkM=";

  types-aiobotocore-autoscaling-plans =
    buildTypesAiobotocorePackage "autoscaling-plans" "2.15.2"
      "sha256-X5Qi6TWVeKi5URcHkEyi1AzyFuZADgNxUFJmtbeRqrQ=";

  types-aiobotocore-backup =
    buildTypesAiobotocorePackage "backup" "2.15.2"
      "sha256-56zIY48+BtCInvbY9qtOVgIijam4suphFS8EHQak+iE=";

  types-aiobotocore-backup-gateway =
    buildTypesAiobotocorePackage "backup-gateway" "2.15.2"
      "sha256-1UIYMYwvmTlGqRoKSoLb7A3W4Ll/WfL7wm3G+kI1GJs=";

  types-aiobotocore-backupstorage =
    buildTypesAiobotocorePackage "backupstorage" "2.13.0"
      "sha256-YUKtBdBrdwL2yqDqOovvzDPbcv/sD8JLRnKz3Oh7iSU=";

  types-aiobotocore-batch =
    buildTypesAiobotocorePackage "batch" "2.15.2"
      "sha256-iu0r4+edD0r5ZJEngGp9W+DiFYiyBXiPdQJk8bRzpU8=";

  types-aiobotocore-billingconductor =
    buildTypesAiobotocorePackage "billingconductor" "2.15.2"
      "sha256-KGnqy6p/63nN613xm8gBGtFHrGEo21kmD1q/GngIStM=";

  types-aiobotocore-braket =
    buildTypesAiobotocorePackage "braket" "2.15.2"
      "sha256-NAcGzPa4k+aAuSReMXK33wKMyaiPP4OCdyCfKmG//Ao=";

  types-aiobotocore-budgets =
    buildTypesAiobotocorePackage "budgets" "2.15.2"
      "sha256-NA0KUMPOrSgXU3ZQ7BcM+gYzfCPbYZecEmckOaWNJKQ=";

  types-aiobotocore-ce =
    buildTypesAiobotocorePackage "ce" "2.15.2"
      "sha256-F8Ve+ImFP00125yzh/wQJGFlXMi7ruP+SLg8dgwFleg=";

  types-aiobotocore-chime =
    buildTypesAiobotocorePackage "chime" "2.15.2"
      "sha256-dtMLfqQNQNJibTPaZI/quovDdWtAKdB3SS2e7PIs7Gk=";

  types-aiobotocore-chime-sdk-identity =
    buildTypesAiobotocorePackage "chime-sdk-identity" "2.15.2"
      "sha256-5UFetlbvMPN1VN862HV5sFvOVcrY2z71ZS31OEXb5uY=";

  types-aiobotocore-chime-sdk-media-pipelines =
    buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "2.15.2"
      "sha256-KMmwUEJfNZ0iNMPPm2+s0aKDB5EmWxT9urrLDiyZEhM=";

  types-aiobotocore-chime-sdk-meetings =
    buildTypesAiobotocorePackage "chime-sdk-meetings" "2.15.2"
      "sha256-7jXpLCcTd5qG6UI8zyZN5ml9D3DsSHWc0KqXhhsyZNI=";

  types-aiobotocore-chime-sdk-messaging =
    buildTypesAiobotocorePackage "chime-sdk-messaging" "2.15.2"
      "sha256-vkA6I/++bwJ77FBGMrrAuvAp6AEMs/t3nJBVr2/pzD8=";

  types-aiobotocore-chime-sdk-voice =
    buildTypesAiobotocorePackage "chime-sdk-voice" "2.15.2"
      "sha256-fxjfPjiKcmvFJ15ukaP0HNU/PUM6mZROighcq6nuTO4=";

  types-aiobotocore-cleanrooms =
    buildTypesAiobotocorePackage "cleanrooms" "2.15.2"
      "sha256-/TD2BimSLmEFw4LfZL6Tve1pBjX4uWlcl/la1S3Gg+c=";

  types-aiobotocore-cloud9 =
    buildTypesAiobotocorePackage "cloud9" "2.15.2"
      "sha256-2ClX7W0zE2+UHZiqjaYdfixO0DxXZ9SuzSwkauvgV7A=";

  types-aiobotocore-cloudcontrol =
    buildTypesAiobotocorePackage "cloudcontrol" "2.15.2"
      "sha256-jPndHm2SNwvMB1qkSk5sjdqjbnHZK4zE8XMOEJoMjcw=";

  types-aiobotocore-clouddirectory =
    buildTypesAiobotocorePackage "clouddirectory" "2.15.2"
      "sha256-qq1iH1BAG4P/4hVyniMOiUdq1JUzYS1n/Oo/fmbiGXg=";

  types-aiobotocore-cloudformation =
    buildTypesAiobotocorePackage "cloudformation" "2.15.2"
      "sha256-nGq1j9tMJw881JOtWtuDSJk36Nl3gkJD0Zi3Pouo0Bc=";

  types-aiobotocore-cloudfront =
    buildTypesAiobotocorePackage "cloudfront" "2.15.2"
      "sha256-gM3Q02aUPpwbNJbm17BayCPeSA7W1LRqNRyU1T7JYRo=";

  types-aiobotocore-cloudhsm =
    buildTypesAiobotocorePackage "cloudhsm" "2.15.2"
      "sha256-MPSf4e7fvmV7HF0FUNOfaaun7EVKfR/WSz3tu0bdREI=";

  types-aiobotocore-cloudhsmv2 =
    buildTypesAiobotocorePackage "cloudhsmv2" "2.15.2"
      "sha256-fM4YaHOSjPBL6b6mtulrmliAfi6RaWX4RT01NbE82bY=";

  types-aiobotocore-cloudsearch =
    buildTypesAiobotocorePackage "cloudsearch" "2.15.2"
      "sha256-UnjA0HGzLRSag2BK5g3a2f3Ocv5D5qQaSF/BWVv6t5U=";

  types-aiobotocore-cloudsearchdomain =
    buildTypesAiobotocorePackage "cloudsearchdomain" "2.15.2"
      "sha256-Kzj6sgsKpqCbuR/Bqvlbj+2k3PSHYPNVs5Ijywir+B8=";

  types-aiobotocore-cloudtrail =
    buildTypesAiobotocorePackage "cloudtrail" "2.15.2"
      "sha256-D3pSFLhphO5LJuAMpR+YMc9LEr6PreuF0jiCblgx+eg=";

  types-aiobotocore-cloudtrail-data =
    buildTypesAiobotocorePackage "cloudtrail-data" "2.15.2"
      "sha256-Ysfo0oRA28j4vYL2p/XSSlPDka1hWOwIFWaozAxjs4Q=";

  types-aiobotocore-cloudwatch =
    buildTypesAiobotocorePackage "cloudwatch" "2.15.2"
      "sha256-OyeSm/UKHTET9Lcp6pgIDknKJqmDkVwqyC3x2yO1d+E=";

  types-aiobotocore-codeartifact =
    buildTypesAiobotocorePackage "codeartifact" "2.15.2"
      "sha256-PAQ5Vck8tG2x7BK1HBSCwchxubdoTJXduXb4fqSKewQ=";

  types-aiobotocore-codebuild =
    buildTypesAiobotocorePackage "codebuild" "2.15.2"
      "sha256-gi8JQlea6kD/k7C+Vd0KwNU9bfiHFfCdkc/VMqdLsNI=";

  types-aiobotocore-codecatalyst =
    buildTypesAiobotocorePackage "codecatalyst" "2.15.2"
      "sha256-A4tsBdng6gf4MdZcB86nOeW7jyBgee7L81Pz4m/rp9s=";

  types-aiobotocore-codecommit =
    buildTypesAiobotocorePackage "codecommit" "2.15.2"
      "sha256-Nmr4IFs+HgkkSHct2m//k/6QPX+uMrBZxpGCQu/ktms=";

  types-aiobotocore-codedeploy =
    buildTypesAiobotocorePackage "codedeploy" "2.15.2"
      "sha256-Oo0U/ymzZx4pm47GnlRsMwXO5WQSKPHKCVLVZ73o+FM=";

  types-aiobotocore-codeguru-reviewer =
    buildTypesAiobotocorePackage "codeguru-reviewer" "2.15.2"
      "sha256-I8W1gWK+HCR1cX+4jRN0bk8IpgACUByK9UCfqKf2H0I=";

  types-aiobotocore-codeguru-security =
    buildTypesAiobotocorePackage "codeguru-security" "2.15.2"
      "sha256-RZkI3thRIWLZgcaupwlyzF1zd0LuLvNv/yDZphoTHT0=";

  types-aiobotocore-codeguruprofiler =
    buildTypesAiobotocorePackage "codeguruprofiler" "2.15.2"
      "sha256-6cB4PY0c8fB2IbLIa3pw5/0gKs9uc+TvqR20i3eiEbw=";

  types-aiobotocore-codepipeline =
    buildTypesAiobotocorePackage "codepipeline" "2.15.2"
      "sha256-NhB4WUrYN7noWIVGiZX5NVQ7jmr/KbZ/gaIGMwQyCtc=";

  types-aiobotocore-codestar =
    buildTypesAiobotocorePackage "codestar" "2.13.3"
      "sha256-Z1ewx2RjmxbOQZ7wXaN54PVOuRs6LP3rMpsrVTacwjo=";

  types-aiobotocore-codestar-connections =
    buildTypesAiobotocorePackage "codestar-connections" "2.15.2"
      "sha256-6bP69xyRpdGzVeyH1tn7u1hLlTNNhBrNtEEXD28bXzU=";

  types-aiobotocore-codestar-notifications =
    buildTypesAiobotocorePackage "codestar-notifications" "2.15.2"
      "sha256-4q4DTYuoKawQXcPfzupceFTaJfYs7eQZR4T2UBIZTJo=";

  types-aiobotocore-cognito-identity =
    buildTypesAiobotocorePackage "cognito-identity" "2.15.2"
      "sha256-7HHA+d6rI6phyN9vj8v8ySfUwRdFtHey3ORUtREDegc=";

  types-aiobotocore-cognito-idp =
    buildTypesAiobotocorePackage "cognito-idp" "2.15.2"
      "sha256-rm/slcrINl8WpprLdkZq3TP7LVHqXLFOwa6hHoZqIuQ=";

  types-aiobotocore-cognito-sync =
    buildTypesAiobotocorePackage "cognito-sync" "2.15.2"
      "sha256-hwUY83vHarKtrDhBWUQjvEWkjzT98QgIsoWzmSCOZVw=";

  types-aiobotocore-comprehend =
    buildTypesAiobotocorePackage "comprehend" "2.15.2"
      "sha256-MplEELAL+rKGyMxJKEPTFEESi4EP1M48pSAXjFP50rA=";

  types-aiobotocore-comprehendmedical =
    buildTypesAiobotocorePackage "comprehendmedical" "2.15.2"
      "sha256-B+vdbBPeANdozCD3G4l2qyQi/IiGePBtV1uC/L8YDL8=";

  types-aiobotocore-compute-optimizer =
    buildTypesAiobotocorePackage "compute-optimizer" "2.15.2"
      "sha256-l3wWbiLHsIg4sg8Ktv4P6uOk1qy9v/uI8iC+jyEv0GY=";

  types-aiobotocore-config =
    buildTypesAiobotocorePackage "config" "2.15.2"
      "sha256-GjC2wY6iIVssYrZi4Ql03bOgI4azJ8toRMhVmqdaF6g=";

  types-aiobotocore-connect =
    buildTypesAiobotocorePackage "connect" "2.15.2"
      "sha256-18PRUxRrcwq/Nz9eWfrWO1uv7RqfgWrdrzTGpf+Y5KA=";

  types-aiobotocore-connect-contact-lens =
    buildTypesAiobotocorePackage "connect-contact-lens" "2.15.2"
      "sha256-FK3HnkkWA8B0PlY/DZUGXPVxpxD25JB3ZNDWMuMJvSA=";

  types-aiobotocore-connectcampaigns =
    buildTypesAiobotocorePackage "connectcampaigns" "2.15.2"
      "sha256-gumozHCg1SpV7NUYJ+SJhsSVlSvb0VQsPSCYLxhV8pA=";

  types-aiobotocore-connectcases =
    buildTypesAiobotocorePackage "connectcases" "2.15.2"
      "sha256-EIcgQ/i9U0nXJY3S0Cw+T3NdELyy3B1mZ640jn10BCw=";

  types-aiobotocore-connectparticipant =
    buildTypesAiobotocorePackage "connectparticipant" "2.15.2"
      "sha256-6ieIdjDnzr3CZqYeXhvoEXN5giZBUfab/xLjQYxMESw=";

  types-aiobotocore-controltower =
    buildTypesAiobotocorePackage "controltower" "2.15.2"
      "sha256-les6NCF44cG768lwj7h3GVYGPW3pF7EozUP04DXB3vI=";

  types-aiobotocore-cur =
    buildTypesAiobotocorePackage "cur" "2.15.2"
      "sha256-9tc5TZx6t46Ppd8gljnFAMu1/mt0asdpMEvHUReTgJ8=";

  types-aiobotocore-customer-profiles =
    buildTypesAiobotocorePackage "customer-profiles" "2.15.2"
      "sha256-5FL2ySDWbh3lUspkWDjk3NNJsknW8iweQub3P/i/vik=";

  types-aiobotocore-databrew =
    buildTypesAiobotocorePackage "databrew" "2.15.2"
      "sha256-2hfisDJAqw4fwtrmzil0sr77khsbFUxxCDMg+fr5Y2k=";

  types-aiobotocore-dataexchange =
    buildTypesAiobotocorePackage "dataexchange" "2.15.2"
      "sha256-SfQXMRIr07Ig/W9PZxvsYdwyuL7BPCTSLrgcR7KYosI=";

  types-aiobotocore-datapipeline =
    buildTypesAiobotocorePackage "datapipeline" "2.15.2"
      "sha256-9jC8u1JuVEOXzS4glOhSUHkkHDMUT/IpvOCOlgXORXc=";

  types-aiobotocore-datasync =
    buildTypesAiobotocorePackage "datasync" "2.15.2"
      "sha256-GpFc9Jp8lpBnVv7KiP+m4opXlbT2GZD/E+FuJIIuM2Q=";

  types-aiobotocore-dax =
    buildTypesAiobotocorePackage "dax" "2.15.2"
      "sha256-8+YMDXMzMA5cdOKtLROJMFr9f/GNoVZcq8DPmQGaGyw=";

  types-aiobotocore-detective =
    buildTypesAiobotocorePackage "detective" "2.15.2"
      "sha256-mhrEwfwNVvz1s//HXYy/afTHgJaM4jKdK2Juo5SDrlU=";

  types-aiobotocore-devicefarm =
    buildTypesAiobotocorePackage "devicefarm" "2.15.2"
      "sha256-o1MUk2hR7gwZS700rIJcjjUYoBHkO1S1Q2jeXlfT01I=";

  types-aiobotocore-devops-guru =
    buildTypesAiobotocorePackage "devops-guru" "2.15.2"
      "sha256-FMt/z56MiTwVuqgC1mfUeGiiv060jAwJ9zRHX3S1Pls=";

  types-aiobotocore-directconnect =
    buildTypesAiobotocorePackage "directconnect" "2.15.2"
      "sha256-tMYlYP5grEjERDEIgJf5uW2tOvKQuIZ9i82/27W/1bI=";

  types-aiobotocore-discovery =
    buildTypesAiobotocorePackage "discovery" "2.15.2"
      "sha256-HecRhn7WhVtnhyf2p3/DfR8GZFe7E+FXOB6Tfo4FhQ0=";

  types-aiobotocore-dlm =
    buildTypesAiobotocorePackage "dlm" "2.15.2"
      "sha256-GPDMhuEywSHsZEb5c75luMAaJ7ezveedU9lNQkLGOzc=";

  types-aiobotocore-dms =
    buildTypesAiobotocorePackage "dms" "2.15.2"
      "sha256-ENyOPp9mO5gnHt/93OFdxAZ0j3qnTdrKHhB0wMLTb6I=";

  types-aiobotocore-docdb =
    buildTypesAiobotocorePackage "docdb" "2.15.2"
      "sha256-eR5tTx2QfrujGb2f4m29Ip31DWNqgalboYDVrGFNLmA=";

  types-aiobotocore-docdb-elastic =
    buildTypesAiobotocorePackage "docdb-elastic" "2.15.2"
      "sha256-q+jMIMYoxDEC+WDY2pqFpyJE8tnc1imKBU0fin17NAg=";

  types-aiobotocore-drs =
    buildTypesAiobotocorePackage "drs" "2.15.2"
      "sha256-kKoZ3i8/bXkoJ5pbj0HVBsYSVwB4eAccmCaPyIPjpp4=";

  types-aiobotocore-ds =
    buildTypesAiobotocorePackage "ds" "2.15.2"
      "sha256-tVONjcSBiwyW8Rok6pm+uzU1chwhrlCSVMsIw0Weh1Q=";

  types-aiobotocore-dynamodb =
    buildTypesAiobotocorePackage "dynamodb" "2.15.2"
      "sha256-0VYAb1ZzBc23YJ1oKwlWRE0Wb8SBltWBNODxckUEtRU=";

  types-aiobotocore-dynamodbstreams =
    buildTypesAiobotocorePackage "dynamodbstreams" "2.15.2"
      "sha256-egDbhJ2SAaw6EQQXGI75x98CBLc+bUyfl8a82RMEmzY=";

  types-aiobotocore-ebs =
    buildTypesAiobotocorePackage "ebs" "2.15.2"
      "sha256-GTCz/fv3NWAD57dhqeGJYYLqQlTYx9eHGCwhKF3xKTQ=";

  types-aiobotocore-ec2 =
    buildTypesAiobotocorePackage "ec2" "2.15.2"
      "sha256-13MWHHnHn17FW8NLfIxyCRwjk09xBG4rKhOn27IFB4M=";

  types-aiobotocore-ec2-instance-connect =
    buildTypesAiobotocorePackage "ec2-instance-connect" "2.15.2"
      "sha256-k+nxNJHuQouSxGSG/nigyvlx7qz0KvWnApGSvLPgOjQ=";

  types-aiobotocore-ecr =
    buildTypesAiobotocorePackage "ecr" "2.15.2"
      "sha256-MSh/z9Wzj6VUFz40U3QHe7ABj8d0HZqEidkG/lIDb6U=";

  types-aiobotocore-ecr-public =
    buildTypesAiobotocorePackage "ecr-public" "2.15.2"
      "sha256-9jRWoSdETNAU8a4kTGj+4Gj+8CU3Y2m3RJSQ2Tlw4fg=";

  types-aiobotocore-ecs =
    buildTypesAiobotocorePackage "ecs" "2.15.2"
      "sha256-ZO4pKMnUf7g4DdKGvEuEzDM3hBEDe5yOSPPXhWDSLiU=";

  types-aiobotocore-efs =
    buildTypesAiobotocorePackage "efs" "2.15.2"
      "sha256-BdXAO/Q7ymBnDbFccevpxTsNs5zcY5VZQtODBmbGEcI=";

  types-aiobotocore-eks =
    buildTypesAiobotocorePackage "eks" "2.15.2"
      "sha256-qKOpyzUhdoKIB253zg/iLeByAYJVsKMZ0hytwY0kU8o=";

  types-aiobotocore-elastic-inference =
    buildTypesAiobotocorePackage "elastic-inference" "2.15.2"
      "sha256-gnZqnLwqGbup02Gaqo/JbAtSMlEl6Rlcm7+3MNQ7MTs=";

  types-aiobotocore-elasticache =
    buildTypesAiobotocorePackage "elasticache" "2.15.2"
      "sha256-DpTquyKW0+uGZZLDnG6+N3k/aEBWaBCd6gx2RiQZ3fk=";

  types-aiobotocore-elasticbeanstalk =
    buildTypesAiobotocorePackage "elasticbeanstalk" "2.15.2"
      "sha256-DV7tOZxA63kA04q+0vUpoTP7QVJ9C3D3NodvcTJJfLg=";

  types-aiobotocore-elastictranscoder =
    buildTypesAiobotocorePackage "elastictranscoder" "2.15.2"
      "sha256-eFBKfNePfk9+765pfX7HVfusysU6shBHA+RFrAXKI4Y=";

  types-aiobotocore-elb =
    buildTypesAiobotocorePackage "elb" "2.15.2"
      "sha256-yzE/hHLfuEO/XJF7PfRxdnxYORfFiJjWeO0RKYXKH1o=";

  types-aiobotocore-elbv2 =
    buildTypesAiobotocorePackage "elbv2" "2.15.2"
      "sha256-sG42uIpI2QoHgo+Uuik2cQnKoINQmFXyaSZ1bVilZtA=";

  types-aiobotocore-emr =
    buildTypesAiobotocorePackage "emr" "2.15.2"
      "sha256-0dBL/3beR2OKwCpxBjS5SnFx93QnHAc6c2LsvTQXI7Y=";

  types-aiobotocore-emr-containers =
    buildTypesAiobotocorePackage "emr-containers" "2.15.2"
      "sha256-xNAW2n4skTQgHzrSgyfhYdPRFjvB/yYyo78rTKqoc6c=";

  types-aiobotocore-emr-serverless =
    buildTypesAiobotocorePackage "emr-serverless" "2.15.2"
      "sha256-rlomQa/70HGPRCG4uf4UCAv5V/TbQ22yUNh9FsFrHGA=";

  types-aiobotocore-entityresolution =
    buildTypesAiobotocorePackage "entityresolution" "2.15.2"
      "sha256-NYKSykt5nfe5ML1b3vOBOUaHdFoEJVt+g29BRJbELhs=";

  types-aiobotocore-es =
    buildTypesAiobotocorePackage "es" "2.15.2"
      "sha256-ACWSJlnd6IjQez53QIKmrV1dtqI13yuohsMw6LC+vzI=";

  types-aiobotocore-events =
    buildTypesAiobotocorePackage "events" "2.15.2"
      "sha256-70GCA4DvVUz2e1oXNKrd+sDUO4FYRI2fA1Q9zg6Yw4Y=";

  types-aiobotocore-evidently =
    buildTypesAiobotocorePackage "evidently" "2.15.2"
      "sha256-5/+S+GXnUQOyu4u5NsirkbakGcq8mRzl8ss578BbMfs=";

  types-aiobotocore-finspace =
    buildTypesAiobotocorePackage "finspace" "2.15.2"
      "sha256-TygJjwA7xBxxEFZ0vcqn3+XsOBMJLpyGnWELj0V7Ifk=";

  types-aiobotocore-finspace-data =
    buildTypesAiobotocorePackage "finspace-data" "2.15.2"
      "sha256-rVleSTHqz08/5zBhzZQio733uy0rXRtFneqtjzQjHGs=";

  types-aiobotocore-firehose =
    buildTypesAiobotocorePackage "firehose" "2.15.2"
      "sha256-+2rDM4qMi1AE4FZQ77Gir1VhONaq/H2NRfiwqhr4s38=";

  types-aiobotocore-fis =
    buildTypesAiobotocorePackage "fis" "2.15.2"
      "sha256-C805H2eghE45jQFdabaYl9JGTjGzKdbpJOvPUT+9etE=";

  types-aiobotocore-fms =
    buildTypesAiobotocorePackage "fms" "2.15.2"
      "sha256-njmD/gMffz9BMGHaFtiLkBfQJs2qMk9fuibvbjEXdpQ=";

  types-aiobotocore-forecast =
    buildTypesAiobotocorePackage "forecast" "2.15.2"
      "sha256-CzK4VMvhuGfSygAKpJOL4zBZuKSiFoHzFmu7DDXwWhs=";

  types-aiobotocore-forecastquery =
    buildTypesAiobotocorePackage "forecastquery" "2.15.2"
      "sha256-wW/e5dWz9NaWGQUcx5E51lsxMp8frgFO0d1dFpr69PA=";

  types-aiobotocore-frauddetector =
    buildTypesAiobotocorePackage "frauddetector" "2.15.2"
      "sha256-TL/Dvkfj1i+cvBuOiyGUwFLZp4AG1VpSfEPzBAkkS24=";

  types-aiobotocore-fsx =
    buildTypesAiobotocorePackage "fsx" "2.15.2"
      "sha256-smCufroBQ6UNbfOTfnr8sJbwRMLcr1d5XO3Fmsr8oF4=";

  types-aiobotocore-gamelift =
    buildTypesAiobotocorePackage "gamelift" "2.15.2"
      "sha256-yu7KH5q1KWa0XZpX4jwtWdYItOjyK2NU824c8RawGC0=";

  types-aiobotocore-gamesparks =
    buildTypesAiobotocorePackage "gamesparks" "2.7.0"
      "sha256-oVbKtuLMPpCQcZYx/cH1Dqjv/t6/uXsveflfFVqfN+8=";

  types-aiobotocore-glacier =
    buildTypesAiobotocorePackage "glacier" "2.15.2"
      "sha256-uvVtYnhswWmCCngRxzSucyWMD8IiUMv51TYH+KvePOo=";

  types-aiobotocore-globalaccelerator =
    buildTypesAiobotocorePackage "globalaccelerator" "2.15.2"
      "sha256-EG+Mub4z9+e1FSOYM9TymEBLkptdBCORAzq5f+FgDb8=";

  types-aiobotocore-glue =
    buildTypesAiobotocorePackage "glue" "2.15.2"
      "sha256-Yt9Bdj97pjBNjzAs4yfhPVXumdZBMR8K6fh9RMVE44U=";

  types-aiobotocore-grafana =
    buildTypesAiobotocorePackage "grafana" "2.15.2"
      "sha256-9SxJCAQTFvkyLLMUjZa8Sw8gmvA7CEmq8plCL2Im2vI=";

  types-aiobotocore-greengrass =
    buildTypesAiobotocorePackage "greengrass" "2.15.2"
      "sha256-o2zx53sUfII3M2riAnSof/W0zjP1aDUMnRmZmFPuQZg=";

  types-aiobotocore-greengrassv2 =
    buildTypesAiobotocorePackage "greengrassv2" "2.15.2"
      "sha256-gFUVkGUva3v9BgvOiSZTJlLEmR8xJPdbtraUXc3uDvE=";

  types-aiobotocore-groundstation =
    buildTypesAiobotocorePackage "groundstation" "2.15.2"
      "sha256-j8tHv3buQXMUNcu13zEqYEgh9y32qvZtGf7RwL/Ded0=";

  types-aiobotocore-guardduty =
    buildTypesAiobotocorePackage "guardduty" "2.15.2"
      "sha256-mvlSXeVh+aqX5nCBiDmLfVY3YzT8S3JGHqTmBECxijQ=";

  types-aiobotocore-health =
    buildTypesAiobotocorePackage "health" "2.15.2"
      "sha256-5aQSWo0L9uonXTWh5tZzukj5Jka2iJQF7Pn55tOR4to=";

  types-aiobotocore-healthlake =
    buildTypesAiobotocorePackage "healthlake" "2.15.2"
      "sha256-MbPcf35D3xDJsReScEoRsMEbNcxCNqP6awnZ3wzEnK4=";

  types-aiobotocore-honeycode =
    buildTypesAiobotocorePackage "honeycode" "2.13.0"
      "sha256-DeeheoQeFEcDH21DSNs2kSR1rjnPLtTgz0yNCFnE+Io=";

  types-aiobotocore-iam =
    buildTypesAiobotocorePackage "iam" "2.15.2"
      "sha256-gj0mnoKF4hCs6oWAil9XS6V/8YnmGVEu6dvh4l3Gl9o=";

  types-aiobotocore-identitystore =
    buildTypesAiobotocorePackage "identitystore" "2.15.2"
      "sha256-OFIHUrjhNBztSEhictiFeLCcIITmihIIs337DT2z6IM=";

  types-aiobotocore-imagebuilder =
    buildTypesAiobotocorePackage "imagebuilder" "2.15.2"
      "sha256-iVa8PY/Ymt8C8x0uWlLAvKcMWhxm/i0Fjy8+wq+vBAs=";

  types-aiobotocore-importexport =
    buildTypesAiobotocorePackage "importexport" "2.15.2"
      "sha256-XODBb05MkRhTPkK44G1dF5PCObngkR0JIenShPg/SEM=";

  types-aiobotocore-inspector =
    buildTypesAiobotocorePackage "inspector" "2.15.2"
      "sha256-W6cJuqZoOgrSHKWvYnLmNpyfswjJbB/pYfSyUYcN5Qg=";

  types-aiobotocore-inspector2 =
    buildTypesAiobotocorePackage "inspector2" "2.15.2"
      "sha256-toUQmdF8Tdakr6cIfAty6mIyHQ7lHyYheEbkrVDsD3g=";

  types-aiobotocore-internetmonitor =
    buildTypesAiobotocorePackage "internetmonitor" "2.15.2"
      "sha256-w8XaOTpY69HY4Y9HXHRzs/UNYVLEJ+OY4vL7K9CYZlU=";

  types-aiobotocore-iot =
    buildTypesAiobotocorePackage "iot" "2.15.2"
      "sha256-KV3EkKI3KoPCwK0lGDyCRF3QzKgdt3VP0mzm0S1Urko=";

  types-aiobotocore-iot-data =
    buildTypesAiobotocorePackage "iot-data" "2.15.2"
      "sha256-j7Kffix+aoo6N0IKNtKuD1cmIxk/yeNXgQUvTwAOFNI=";

  types-aiobotocore-iot-jobs-data =
    buildTypesAiobotocorePackage "iot-jobs-data" "2.15.2"
      "sha256-rbNjx7Moa6xY8aQRNF54hurpbr/jLhDfR0IXZNKaZXg=";

  types-aiobotocore-iot-roborunner =
    buildTypesAiobotocorePackage "iot-roborunner" "2.12.2"
      "sha256-O/nGvYfUibI4EvHgONtkYHFv/dZSpHCehXjietPiMJo=";

  types-aiobotocore-iot1click-devices =
    buildTypesAiobotocorePackage "iot1click-devices" "2.15.2"
      "sha256-OK7Yw0t1rSXQz2BJrP0zYorMjGGdac2SS9IpKNrF6y4=";

  types-aiobotocore-iot1click-projects =
    buildTypesAiobotocorePackage "iot1click-projects" "2.15.2"
      "sha256-kNEVudATczB+qs0XyihgJbmH/02Ds8tGuzKWQ5IDj4M=";

  types-aiobotocore-iotanalytics =
    buildTypesAiobotocorePackage "iotanalytics" "2.15.2"
      "sha256-scMpD4ZGJyTA97b70t80fE/mQkS5LwumJCWD2v7ul9w=";

  types-aiobotocore-iotdeviceadvisor =
    buildTypesAiobotocorePackage "iotdeviceadvisor" "2.15.2"
      "sha256-XLS46QND2ZNbm0pB73gGrkJVS8ulEoBPAf2EucNQqNA=";

  types-aiobotocore-iotevents =
    buildTypesAiobotocorePackage "iotevents" "2.15.2"
      "sha256-b21od8f3xlkyMebl6QFNKqhGCO4FcioMWX8odrKolnk=";

  types-aiobotocore-iotevents-data =
    buildTypesAiobotocorePackage "iotevents-data" "2.15.2"
      "sha256-laNqog/9QdCDOtNhmBwki2hfJur9M+M6rqdVVZZKRyk=";

  types-aiobotocore-iotfleethub =
    buildTypesAiobotocorePackage "iotfleethub" "2.15.2"
      "sha256-cXdG48rRVvZtvg0nnPcl6lDmyukhQpGH2tHyMhp6KpA=";

  types-aiobotocore-iotfleetwise =
    buildTypesAiobotocorePackage "iotfleetwise" "2.15.2"
      "sha256-Qokco8UgSqsRZ03NawYHvyCx9qc+/q2mYPUEp+OhqOA=";

  types-aiobotocore-iotsecuretunneling =
    buildTypesAiobotocorePackage "iotsecuretunneling" "2.15.2"
      "sha256-Iq6WU6a7bfb8+ob0feMoVbJr0J3tQI7L0nsV7X7E3rM=";

  types-aiobotocore-iotsitewise =
    buildTypesAiobotocorePackage "iotsitewise" "2.15.2"
      "sha256-9XjABgFHnbEIztv7CiS2QX/dUgawqic3XEJ5CSt0oEk=";

  types-aiobotocore-iotthingsgraph =
    buildTypesAiobotocorePackage "iotthingsgraph" "2.15.2"
      "sha256-pbVgFQOcfnEjPRYsXz+XHEh9Xa0aAZvTD7coaYt2uR0=";

  types-aiobotocore-iottwinmaker =
    buildTypesAiobotocorePackage "iottwinmaker" "2.15.2"
      "sha256-hyyW7WVaxyvus78zPDvy9g8J1/ZY3r0RbjhcgApVx0E=";

  types-aiobotocore-iotwireless =
    buildTypesAiobotocorePackage "iotwireless" "2.15.2"
      "sha256-+vc1U5s8yLnpBsrB1rzuwZj1z/ECe4NTUfIcuO5FRdk=";

  types-aiobotocore-ivs =
    buildTypesAiobotocorePackage "ivs" "2.15.2"
      "sha256-lkDOjzhDWTFECa+hxb8EIVpxd+j9FSHGb9L9fRePNRo=";

  types-aiobotocore-ivs-realtime =
    buildTypesAiobotocorePackage "ivs-realtime" "2.15.2"
      "sha256-hFFPTJHySEHbcNwgg6YnU8GJBDA8y2F1pyAY2jpw8CE=";

  types-aiobotocore-ivschat =
    buildTypesAiobotocorePackage "ivschat" "2.15.2"
      "sha256-/nKK+JmeOr6zG8OEeNvBT1cWUTD55gK/LCFze3/P4p8=";

  types-aiobotocore-kafka =
    buildTypesAiobotocorePackage "kafka" "2.15.2"
      "sha256-H+1xCc+/5RZ684yMxhzqUTysj9QvUMMVMcd+kI9PGZQ=";

  types-aiobotocore-kafkaconnect =
    buildTypesAiobotocorePackage "kafkaconnect" "2.15.2"
      "sha256-JH+0rJQmzsJ/LBWMSp/UsjtFpD6FmMtkfr0+9tJKKoY=";

  types-aiobotocore-kendra =
    buildTypesAiobotocorePackage "kendra" "2.15.2"
      "sha256-+gQGQmC8lgxAF0Pyo7mloBLN/iSfqvM67KyntXFU4wg=";

  types-aiobotocore-kendra-ranking =
    buildTypesAiobotocorePackage "kendra-ranking" "2.15.2"
      "sha256-Qg/EN+M3YqqnYkYBFm34YoDnxfEFbmA7YUId/+YmEME=";

  types-aiobotocore-keyspaces =
    buildTypesAiobotocorePackage "keyspaces" "2.15.2"
      "sha256-QjwiOj8YhfmCjmM+7C4WP5kPtQcpLb7TbXam/+XMH0U=";

  types-aiobotocore-kinesis =
    buildTypesAiobotocorePackage "kinesis" "2.15.2"
      "sha256-1kwvF+RK4CjpEyv/BAi7u6R4kdL2y6PiWrp4pWt38yw=";

  types-aiobotocore-kinesis-video-archived-media =
    buildTypesAiobotocorePackage "kinesis-video-archived-media" "2.15.2"
      "sha256-vudWpiyA9u3f5v191Ajh/K5EvZJLeaKxqjo5oPjRbuk=";

  types-aiobotocore-kinesis-video-media =
    buildTypesAiobotocorePackage "kinesis-video-media" "2.15.2"
      "sha256-t2FvtZiKBLfD/RADQ3+6ZzfUXUnq/PYMAMHj1YQmobU=";

  types-aiobotocore-kinesis-video-signaling =
    buildTypesAiobotocorePackage "kinesis-video-signaling" "2.15.2"
      "sha256-ImrtDqLs6k8nQBtXa0gEH34kFlBorZSrX1hCRqV130o=";

  types-aiobotocore-kinesis-video-webrtc-storage =
    buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "2.15.2"
      "sha256-Jb1oWeQgXmLP7fFSWG5ZgNLzUaZRITNGhVWWMlfQLQc=";

  types-aiobotocore-kinesisanalytics =
    buildTypesAiobotocorePackage "kinesisanalytics" "2.15.2"
      "sha256-LXVmEz3iHWl3Svg5F3X06CJvStcQdwOlSS8m+uQj+Hk=";

  types-aiobotocore-kinesisanalyticsv2 =
    buildTypesAiobotocorePackage "kinesisanalyticsv2" "2.15.2"
      "sha256-RCz0ySwc+gWzyVDKTFT2pXkqy9PEmg6uF8BOoLHzvmA=";

  types-aiobotocore-kinesisvideo =
    buildTypesAiobotocorePackage "kinesisvideo" "2.15.2"
      "sha256-m1movOOFQVLCzKSCWSoYv03Ig9D0qJ17O73tk4XaTX0=";

  types-aiobotocore-kms =
    buildTypesAiobotocorePackage "kms" "2.15.2"
      "sha256-9EXCtfSVjSuyszl3H8Llk5j/KYmU9HSUFP/k1Btrlv4=";

  types-aiobotocore-lakeformation =
    buildTypesAiobotocorePackage "lakeformation" "2.15.2"
      "sha256-zYavyl1U94TCsmjyVhedtexjl0B+2FN3jo6Dg2adePo=";

  types-aiobotocore-lambda =
    buildTypesAiobotocorePackage "lambda" "2.15.2"
      "sha256-vRsrDk4dzT7wsCeaNE2dnf8blwM/Unb3lAN8Dc0x7SA=";

  types-aiobotocore-lex-models =
    buildTypesAiobotocorePackage "lex-models" "2.15.2"
      "sha256-jSO3wtWRgXuPCHFfFgBDw0lMsOYb1IjqzCmo1WX6Gr4=";

  types-aiobotocore-lex-runtime =
    buildTypesAiobotocorePackage "lex-runtime" "2.15.2"
      "sha256-BdaqbSjKpsFeDTh7ttj1j48YDSMP651UpgmqmM82KpI=";

  types-aiobotocore-lexv2-models =
    buildTypesAiobotocorePackage "lexv2-models" "2.15.2"
      "sha256-sJZcOkCK9x7RsFo6mVR7FGmictWprwVUlPpzuMbQEn4=";

  types-aiobotocore-lexv2-runtime =
    buildTypesAiobotocorePackage "lexv2-runtime" "2.15.2"
      "sha256-dmn/Q2ljn4+AIryiIcytMGxAS92Q0vZdv2yuuA3/0vo=";

  types-aiobotocore-license-manager =
    buildTypesAiobotocorePackage "license-manager" "2.15.2"
      "sha256-HfsmPqnNEoBM/Q6d5GbhV1qykXlO2KE9DURQi7cEnBo=";

  types-aiobotocore-license-manager-linux-subscriptions =
    buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "2.15.2"
      "sha256-u4pZBE0deFVSfZ4B5LXXXOBDb/SkpnCTi1pHQ7ZVyb0=";

  types-aiobotocore-license-manager-user-subscriptions =
    buildTypesAiobotocorePackage "license-manager-user-subscriptions" "2.15.2"
      "sha256-Ldd8K7DIjE0cNqvdWWVno2ehVzmtdt9IyLdUKuM1k5k=";

  types-aiobotocore-lightsail =
    buildTypesAiobotocorePackage "lightsail" "2.15.2"
      "sha256-Odx5WGYh8Xlv6ahMuNjj3XzXftrKQdILAoGMoDz9aBQ=";

  types-aiobotocore-location =
    buildTypesAiobotocorePackage "location" "2.15.2"
      "sha256-KjQ02j1x55qp+6RA1pWe4z53rUgd0Z59dp4vjHVSwlY=";

  types-aiobotocore-logs =
    buildTypesAiobotocorePackage "logs" "2.15.2"
      "sha256-4cxlv7ZSVy92Ewm5jgjqAXRKjFOczaYhl74zR+wGltU=";

  types-aiobotocore-lookoutequipment =
    buildTypesAiobotocorePackage "lookoutequipment" "2.15.2"
      "sha256-gEmhfU9rLE2hFRumda25SSBqhgOgZFza0lPiN+z6sGs=";

  types-aiobotocore-lookoutmetrics =
    buildTypesAiobotocorePackage "lookoutmetrics" "2.15.2"
      "sha256-VN3E+UkX8wvQqY3J5SSIfCcpDM/wfuqMvX6KbMUfFkU=";

  types-aiobotocore-lookoutvision =
    buildTypesAiobotocorePackage "lookoutvision" "2.15.2"
      "sha256-6Tpk8lEKtYjIiXNI1VgH65RkCc6/Cp9qhB/5NHtl0ok=";

  types-aiobotocore-m2 =
    buildTypesAiobotocorePackage "m2" "2.15.2"
      "sha256-ZK+mMbIaY2BmeZU0P4GTMcbTcUOJ1k0ErkRTDu/LdeQ=";

  types-aiobotocore-machinelearning =
    buildTypesAiobotocorePackage "machinelearning" "2.15.2"
      "sha256-CkcJc43D+K24tN+MO48iIpkWINQ5v39Us6XiAerY5ug=";

  types-aiobotocore-macie =
    buildTypesAiobotocorePackage "macie" "2.7.0"
      "sha256-hJJtGsK2b56nKX1ZhiarC+ffyjHYWRiC8II4oyDZWWw=";

  types-aiobotocore-macie2 =
    buildTypesAiobotocorePackage "macie2" "2.15.2"
      "sha256-XVUlAYWbCKlIHDD0KnAf1x5aIzPQOwDF/MUf2Cn0w2E=";

  types-aiobotocore-managedblockchain =
    buildTypesAiobotocorePackage "managedblockchain" "2.15.2"
      "sha256-bS54O33UB62+P6Lz+u4zzBDMP/dGG0EQYzJwabrLEzE=";

  types-aiobotocore-managedblockchain-query =
    buildTypesAiobotocorePackage "managedblockchain-query" "2.15.2"
      "sha256-tI0WjxdRupLqL437/Q9W7Yd6PEzU2GBsfAGU/3UssG8=";

  types-aiobotocore-marketplace-catalog =
    buildTypesAiobotocorePackage "marketplace-catalog" "2.15.2"
      "sha256-L23ZQ4bGhQtHat3xWT/IIbrTr4UnZ1wY2Cco9Z4ae4s=";

  types-aiobotocore-marketplace-entitlement =
    buildTypesAiobotocorePackage "marketplace-entitlement" "2.15.2"
      "sha256-7SXKNz2Lz2aewLAcKVvuIZShdGCRHZbwyKy2araKo3A=";

  types-aiobotocore-marketplacecommerceanalytics =
    buildTypesAiobotocorePackage "marketplacecommerceanalytics" "2.15.2"
      "sha256-qbAaQevFItdsIk7Je5ng9EMrTgVRfMmSmCeYSH7BXMY=";

  types-aiobotocore-mediaconnect =
    buildTypesAiobotocorePackage "mediaconnect" "2.15.2"
      "sha256-DwyW/Lz2TcJUpS21SZAJCZR9nySSFN7/k4Hwea51QDo=";

  types-aiobotocore-mediaconvert =
    buildTypesAiobotocorePackage "mediaconvert" "2.15.2"
      "sha256-xEi7pQSuq7vkcGrZx7/LSHDiGc0yRy5yDLB+R1Sw9i4=";

  types-aiobotocore-medialive =
    buildTypesAiobotocorePackage "medialive" "2.15.2"
      "sha256-XejVpsX2j0u2TTB7y/ZkwCeBhKLQOpCuJm0BL88ocAg=";

  types-aiobotocore-mediapackage =
    buildTypesAiobotocorePackage "mediapackage" "2.15.2"
      "sha256-SxNd+WdyHA0ijqV3urXldQXeMew19EUydNArzMdHSZk=";

  types-aiobotocore-mediapackage-vod =
    buildTypesAiobotocorePackage "mediapackage-vod" "2.15.2"
      "sha256-OaJv/gY2yhR6rMstJx88NQY/IBO9NxqleUY4gfq5dd0=";

  types-aiobotocore-mediapackagev2 =
    buildTypesAiobotocorePackage "mediapackagev2" "2.15.2"
      "sha256-8mQbc9Wp8PvcyHocdcR9VS1jyJYGnwCuB4qk1iGq4DA=";

  types-aiobotocore-mediastore =
    buildTypesAiobotocorePackage "mediastore" "2.15.2"
      "sha256-HvMe5b/WoUL6osOakD4z3fGfC5dPWphZFXijpqVL4tk=";

  types-aiobotocore-mediastore-data =
    buildTypesAiobotocorePackage "mediastore-data" "2.15.2"
      "sha256-FqbPAwpzikmawdrNa1/R0SGj0G4WqGRxBT6xceJHX1A=";

  types-aiobotocore-mediatailor =
    buildTypesAiobotocorePackage "mediatailor" "2.15.2"
      "sha256-iHjBmnvn2Rzo62Ep1bjJoZKNVGArtwxdOZoT1+SneqE=";

  types-aiobotocore-medical-imaging =
    buildTypesAiobotocorePackage "medical-imaging" "2.15.2"
      "sha256-UXzTpoFnuJQRwJfahcWSfYO9lWuEP9W+CZWiGdiupPQ=";

  types-aiobotocore-memorydb =
    buildTypesAiobotocorePackage "memorydb" "2.15.2"
      "sha256-lFetqAmP6lwKTmJEhS1wcydBgePh4/hhkq/ngHAqxHw=";

  types-aiobotocore-meteringmarketplace =
    buildTypesAiobotocorePackage "meteringmarketplace" "2.15.2"
      "sha256-wT3cz2FprMmyhag/0ZODuHFiB+qKD6LKvehs8PWP8m4=";

  types-aiobotocore-mgh =
    buildTypesAiobotocorePackage "mgh" "2.15.2"
      "sha256-uxukwGScWYD2oCXu8vPu6o2BJiLtnMuIXIgqXFF5VGA=";

  types-aiobotocore-mgn =
    buildTypesAiobotocorePackage "mgn" "2.15.2"
      "sha256-lXlNAFEQbteRMGiOfSpBF1AF12UYjc64sXaOVN6KZRg=";

  types-aiobotocore-migration-hub-refactor-spaces =
    buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "2.15.2"
      "sha256-Ndj1DdPIam1NG5zAzKJkilE0TDHGykywc2hpxvWNyPY=";

  types-aiobotocore-migrationhub-config =
    buildTypesAiobotocorePackage "migrationhub-config" "2.15.2"
      "sha256-LXu7VQkVpgqIMD7ucMV4Kj/Zv6FoFDvLX8rYjtO2ijg=";

  types-aiobotocore-migrationhuborchestrator =
    buildTypesAiobotocorePackage "migrationhuborchestrator" "2.15.2"
      "sha256-Te1jZDw3UjMBM6DlCj38Nn42xRt86WzHGaJnjbobDMs=";

  types-aiobotocore-migrationhubstrategy =
    buildTypesAiobotocorePackage "migrationhubstrategy" "2.15.2"
      "sha256-IkE/I9X6FXqNBsMUM2/lQ2SVIIaY8PtAyx0d4XA94BE=";

  types-aiobotocore-mobile =
    buildTypesAiobotocorePackage "mobile" "2.13.2"
      "sha256-OxB91BCAmYnY72JBWZaBlEkpAxN2Q5aY4i1Pt3eD9hc=";

  types-aiobotocore-mq =
    buildTypesAiobotocorePackage "mq" "2.15.2"
      "sha256-VY6tLjwGYbJte8xoit/gIVuMSGkygYhpGrCVwmkcD+c=";

  types-aiobotocore-mturk =
    buildTypesAiobotocorePackage "mturk" "2.15.2"
      "sha256-wmnepAFZGXOk6+/G0XToAQBxPyrtmyGIl9DYcaQIwrI=";

  types-aiobotocore-mwaa =
    buildTypesAiobotocorePackage "mwaa" "2.15.2"
      "sha256-sjXYuZf6yffeiu4A/FYXebGTFr408e7QKNmML2y2yTA=";

  types-aiobotocore-neptune =
    buildTypesAiobotocorePackage "neptune" "2.15.2"
      "sha256-hpnEfol8cLYk8AuIaBRitNIJoEMv1jvWzNED1b4xqfA=";

  types-aiobotocore-network-firewall =
    buildTypesAiobotocorePackage "network-firewall" "2.15.2"
      "sha256-rMaMUBlbxJKeRIX/eEKtYrO0mXiDdWyZ0x4GfoDw2iY=";

  types-aiobotocore-networkmanager =
    buildTypesAiobotocorePackage "networkmanager" "2.15.2"
      "sha256-JbN4suHNPpgGnkz4HnEmZXF4HMVnzMDd9DO6/xnzOgo=";

  types-aiobotocore-nimble =
    buildTypesAiobotocorePackage "nimble" "2.15.2"
      "sha256-PChX5Jbgr0d1YaTZU9AbX3cM7NrhkyunK6/X3l+I8Q0=";

  types-aiobotocore-oam =
    buildTypesAiobotocorePackage "oam" "2.15.2"
      "sha256-VYimOD1qzkRxpieACK1D5Flm1jTMLEkbiRhOczOPiCw=";

  types-aiobotocore-omics =
    buildTypesAiobotocorePackage "omics" "2.15.2"
      "sha256-NjwwQvLdS4yaH+0lWiO3WdCbYkEm7Xy+WDZ0fZv0iO4=";

  types-aiobotocore-opensearch =
    buildTypesAiobotocorePackage "opensearch" "2.15.2"
      "sha256-P/5KsryA4IRZ2B8Jvyb4UyhBwIrxAdR1Z1C0KfPgurQ=";

  types-aiobotocore-opensearchserverless =
    buildTypesAiobotocorePackage "opensearchserverless" "2.15.2"
      "sha256-kshUKyoAIgVyIMntWuCrAD+WZ9usxXH1k78y/DqTWvc=";

  types-aiobotocore-opsworks =
    buildTypesAiobotocorePackage "opsworks" "2.15.2"
      "sha256-KJfyFi4FHoqicPmLnsknrR0Bs2rXiM5fNneR2i9SG6E=";

  types-aiobotocore-opsworkscm =
    buildTypesAiobotocorePackage "opsworkscm" "2.15.2"
      "sha256-T+JObJ+jB48uaS39I68YyDxggoWiMj/8Di1PzDCQChU=";

  types-aiobotocore-organizations =
    buildTypesAiobotocorePackage "organizations" "2.15.2"
      "sha256-6TYjbdnUOCc29kWZ3RsdscEK40uS0q5fcwhVAZ46yKQ=";

  types-aiobotocore-osis =
    buildTypesAiobotocorePackage "osis" "2.15.2"
      "sha256-zRFrveWqmZ67/Cb8vnmgUCwVgt9oUn9qS8YegKqKwCw=";

  types-aiobotocore-outposts =
    buildTypesAiobotocorePackage "outposts" "2.15.2"
      "sha256-+Pa7Gy+7aend87amJsaob24WXQWdrpA+Tj17dnrEFaQ=";

  types-aiobotocore-panorama =
    buildTypesAiobotocorePackage "panorama" "2.15.2"
      "sha256-7BW09/NkN4AFwR8qhvTs8nYSflG9cozyPFIpS8/Y6FQ=";

  types-aiobotocore-payment-cryptography =
    buildTypesAiobotocorePackage "payment-cryptography" "2.15.2"
      "sha256-4tNGI26K1ejnLwfsCOU0Iy8JiQyjMmDsn6JP9RMG5MI=";

  types-aiobotocore-payment-cryptography-data =
    buildTypesAiobotocorePackage "payment-cryptography-data" "2.15.2"
      "sha256-ZXVhYvin2ZjjusSXkg3byqW5QHtFEyd1uufi9nWvutM=";

  types-aiobotocore-personalize =
    buildTypesAiobotocorePackage "personalize" "2.15.2"
      "sha256-3CPcx8rP6N59eoooZej/qcySZYIiRl7j8B96KB9CD7s=";

  types-aiobotocore-personalize-events =
    buildTypesAiobotocorePackage "personalize-events" "2.15.2"
      "sha256-jW4ZIOw2dPuebRyaQzl/aV5X5g3d+HyR96nK15KabKA=";

  types-aiobotocore-personalize-runtime =
    buildTypesAiobotocorePackage "personalize-runtime" "2.15.2"
      "sha256-hQiddMrXRgWmQjIiytIIk3S3hYAyiSyM5wfGQ/PQtuo=";

  types-aiobotocore-pi =
    buildTypesAiobotocorePackage "pi" "2.15.2"
      "sha256-S+Zf7VW+F1x4gnWVYJyTyvA/31mfBlHvVtDiSokuCEo=";

  types-aiobotocore-pinpoint =
    buildTypesAiobotocorePackage "pinpoint" "2.15.2"
      "sha256-ajqWceNuGO3+ABzNi5rFook4tdWo7diCkfYIaNnCnqI=";

  types-aiobotocore-pinpoint-email =
    buildTypesAiobotocorePackage "pinpoint-email" "2.15.2"
      "sha256-pMgodwm9Ihz99d/C+hP5Z5ZxSA9WQ5sOJu407j6w+9s=";

  types-aiobotocore-pinpoint-sms-voice =
    buildTypesAiobotocorePackage "pinpoint-sms-voice" "2.15.2"
      "sha256-8E6frTBvs14nYtfhaWi+/5HTDhNGWcHMAktQ+DhARdY=";

  types-aiobotocore-pinpoint-sms-voice-v2 =
    buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "2.15.2"
      "sha256-WWwFEhAEls6dVX9WNZrWywV4egtd1bt5n3pOCEb1p00=";

  types-aiobotocore-pipes =
    buildTypesAiobotocorePackage "pipes" "2.15.2"
      "sha256-5QD0FgHLNbU9BnppJtB7RKMg9cdOz0ILkF/gkR7igs4=";

  types-aiobotocore-polly =
    buildTypesAiobotocorePackage "polly" "2.15.2"
      "sha256-r6onIkXMgieQ9xtjuaGsQqq52OOq6k/DUz3jO5uYi6U=";

  types-aiobotocore-pricing =
    buildTypesAiobotocorePackage "pricing" "2.15.2"
      "sha256-5IvT+CsBX3WBfz0f2CVGAtal+SprCAqO7CGKOwSLpLQ=";

  types-aiobotocore-privatenetworks =
    buildTypesAiobotocorePackage "privatenetworks" "2.15.2"
      "sha256-gfnx+RgpiZCtLmIPWuc3Lz5JM+IgxMsAKvOqxiwJmew=";

  types-aiobotocore-proton =
    buildTypesAiobotocorePackage "proton" "2.15.2"
      "sha256-MGL3z4ULEon/EjSCLuN2sB6tAepic+ZG+vVAani6qpQ=";

  types-aiobotocore-qldb =
    buildTypesAiobotocorePackage "qldb" "2.15.2"
      "sha256-dX2wLRIg977khlZoVYd9y1UzRMLDorIBHvOhXX2r+KI=";

  types-aiobotocore-qldb-session =
    buildTypesAiobotocorePackage "qldb-session" "2.15.2"
      "sha256-omOG7aWjTBdIHElYE14X7DyQKBNGY5yfOg4IeiL0ooo=";

  types-aiobotocore-quicksight =
    buildTypesAiobotocorePackage "quicksight" "2.15.2"
      "sha256-U+151xlZAGz+JgIJD/mU9C1z85UCimqOubaX3x/0nhg=";

  types-aiobotocore-ram =
    buildTypesAiobotocorePackage "ram" "2.15.2"
      "sha256-lp2oA2JBXSgniu5MJR6F+HeSczlc+w4wj7zyPggA6dY=";

  types-aiobotocore-rbin =
    buildTypesAiobotocorePackage "rbin" "2.15.2"
      "sha256-sFrrTWJkFCMkF4gxH3nQvctzMag234P3gN0tKyvvZrE=";

  types-aiobotocore-rds =
    buildTypesAiobotocorePackage "rds" "2.15.2"
      "sha256-lz03bzDbmAvjc0s5hKeuOohycOcj1wAZsePeWYGp5ts=";

  types-aiobotocore-rds-data =
    buildTypesAiobotocorePackage "rds-data" "2.15.2"
      "sha256-WTb2V9H5MmEtDsboJmQPoRLRNWCL1Ot+myoRRBpDphw=";

  types-aiobotocore-redshift =
    buildTypesAiobotocorePackage "redshift" "2.15.2"
      "sha256-ErKPn+GGiujvvRps8FIY+QRo0ycQQ4t8tYE64iwqrw8=";

  types-aiobotocore-redshift-data =
    buildTypesAiobotocorePackage "redshift-data" "2.15.2"
      "sha256-bxQv1ESSEBG3elReQbKurlEv3jMrfdztBbn7kIwrlJk=";

  types-aiobotocore-redshift-serverless =
    buildTypesAiobotocorePackage "redshift-serverless" "2.15.2"
      "sha256-EyciPvrLkG0maSoyVFRkV1gA30vPF+MybM0j4gtwjwA=";

  types-aiobotocore-rekognition =
    buildTypesAiobotocorePackage "rekognition" "2.15.2"
      "sha256-dqoAVV2zwCwgfIBb72gLSXminPq4FgPYYzZlzxumkrY=";

  types-aiobotocore-resiliencehub =
    buildTypesAiobotocorePackage "resiliencehub" "2.15.2"
      "sha256-o8TBetwKqzHJj7ISkhgX9iPpt8CvZ5M3LFYmfEqmCDI=";

  types-aiobotocore-resource-explorer-2 =
    buildTypesAiobotocorePackage "resource-explorer-2" "2.15.2"
      "sha256-hQ+Jc8m4q7Q7zHSJyCL62ugAMNeFLbEA8LJ6VQ9LVHo=";

  types-aiobotocore-resource-groups =
    buildTypesAiobotocorePackage "resource-groups" "2.15.2"
      "sha256-T1gIcrRPXWbfzYReB/MBLcYUjUhiDqbcah/kGKx6g9s=";

  types-aiobotocore-resourcegroupstaggingapi =
    buildTypesAiobotocorePackage "resourcegroupstaggingapi" "2.15.2"
      "sha256-fa/EoxdXi5Vd0R2eHexVx9PSiesVyw/0okGpHIGd7I8=";

  types-aiobotocore-robomaker =
    buildTypesAiobotocorePackage "robomaker" "2.15.2"
      "sha256-ShnMPJzy/isQNqwYiBBb3B7tEr/ydi6weW/J+Bu6XoU=";

  types-aiobotocore-rolesanywhere =
    buildTypesAiobotocorePackage "rolesanywhere" "2.15.2"
      "sha256-Td97qtNPStvbV/1vILYZ/TTtpngndk/7s1wAORakKeQ=";

  types-aiobotocore-route53 =
    buildTypesAiobotocorePackage "route53" "2.15.2"
      "sha256-olwrQiY0EOvIJMFX/wQKT1dKzIGDlOEMrqvx2cVxOCA=";

  types-aiobotocore-route53-recovery-cluster =
    buildTypesAiobotocorePackage "route53-recovery-cluster" "2.15.2"
      "sha256-T1kYpmeMmvQOZkxqeCDbab2HNFBcX7I7wc28gB66UHU=";

  types-aiobotocore-route53-recovery-control-config =
    buildTypesAiobotocorePackage "route53-recovery-control-config" "2.15.2"
      "sha256-/yWRQIwfwZjkDooNl3GmbGrlxD1vSTk/2NrrQpG3IJc=";

  types-aiobotocore-route53-recovery-readiness =
    buildTypesAiobotocorePackage "route53-recovery-readiness" "2.15.2"
      "sha256-1+TJUQ5LPWnHDcR41at5C5lKf92euYVer6BXLfs8r3A=";

  types-aiobotocore-route53domains =
    buildTypesAiobotocorePackage "route53domains" "2.15.2"
      "sha256-xsAKhJBxAWzhCP2lUwcQ9jp4M/Av0nOae+ToMG4p1hQ=";

  types-aiobotocore-route53resolver =
    buildTypesAiobotocorePackage "route53resolver" "2.15.2"
      "sha256-JNzO/R8OfmPhpPBCt2YIS420mXAuKadpB+/h8r1VccY=";

  types-aiobotocore-rum =
    buildTypesAiobotocorePackage "rum" "2.15.2"
      "sha256-KEjeiHaU2MjBHxDJzFgIZtsfnj/7vEzlixeAu8+KRm4=";

  types-aiobotocore-s3 =
    buildTypesAiobotocorePackage "s3" "2.15.2"
      "sha256-Hr7IrJ3+a7+7OT6zTSkEdnBfq3aNKVjG0h2dv7dScs4=";

  types-aiobotocore-s3control =
    buildTypesAiobotocorePackage "s3control" "2.15.2"
      "sha256-4kWotne4SnLV1rEvWJLw/jP+ZiL1BmHQ4uxj/QW2Hb4=";

  types-aiobotocore-s3outposts =
    buildTypesAiobotocorePackage "s3outposts" "2.15.2"
      "sha256-Dfp04DBqhQBWEokBwtw/ALimFq6ZgzrrV5bZfgG9aQw=";

  types-aiobotocore-sagemaker =
    buildTypesAiobotocorePackage "sagemaker" "2.15.2"
      "sha256-jEAVncpRneLhQ7MN5sdwvRexiTXHBRLD1gfRng2LtXk=";

  types-aiobotocore-sagemaker-a2i-runtime =
    buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "2.15.2"
      "sha256-4pAalrOg0umvRj/3xRDsziWl/wHPf+37NhOurtvLJd8=";

  types-aiobotocore-sagemaker-edge =
    buildTypesAiobotocorePackage "sagemaker-edge" "2.15.2"
      "sha256-rCEEed2WVtd506aeYG+KX+ADuqwc3TuYIBO9aGzBjGM=";

  types-aiobotocore-sagemaker-featurestore-runtime =
    buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "2.15.2"
      "sha256-y/5KuNWy3832PAvvPxcTFYrGeTS0SOA3cFM6oaQFGD8=";

  types-aiobotocore-sagemaker-geospatial =
    buildTypesAiobotocorePackage "sagemaker-geospatial" "2.15.2"
      "sha256-joXbxcuxaBX4Nl18oFhhSz5AXme0zVcpmw/vWoziNu4=";

  types-aiobotocore-sagemaker-metrics =
    buildTypesAiobotocorePackage "sagemaker-metrics" "2.15.2"
      "sha256-LgQn2sOOv7dV2XP87XcD5dz8ZulGK5Ny3wl/YLAAguU=";

  types-aiobotocore-sagemaker-runtime =
    buildTypesAiobotocorePackage "sagemaker-runtime" "2.15.2"
      "sha256-YMgZ7YH3iTjE26HrcOCLLqs3FF+0f8Dil8t5bTA+gRo=";

  types-aiobotocore-savingsplans =
    buildTypesAiobotocorePackage "savingsplans" "2.15.2"
      "sha256-FQaInT6mcJ+f0YooDo4vVJA7ZKrJv2w3Jg29L1GUe7U=";

  types-aiobotocore-scheduler =
    buildTypesAiobotocorePackage "scheduler" "2.15.2"
      "sha256-9HbcEJfpfXXSQvTtYXCN5cQSwisIk57OsF+MYecLFh0=";

  types-aiobotocore-schemas =
    buildTypesAiobotocorePackage "schemas" "2.15.2"
      "sha256-SvenxkkMais2m/zfzdAehy6Dl5uOZpuBEWq8SWg1z6Q=";

  types-aiobotocore-sdb =
    buildTypesAiobotocorePackage "sdb" "2.15.2"
      "sha256-/RPhNimi1jEbPiHvJmtkvL/t1dlnYguQsQ2C3uvM9pA=";

  types-aiobotocore-secretsmanager =
    buildTypesAiobotocorePackage "secretsmanager" "2.15.2"
      "sha256-js9F7mkNtanyv2AVZPFGs88b21Ng99yQ7Yrc/UP4LKA=";

  types-aiobotocore-securityhub =
    buildTypesAiobotocorePackage "securityhub" "2.15.2"
      "sha256-yrI7hTvxsInp64WWMfMvqBx0qkpoYF8fryV2WC7HrCU=";

  types-aiobotocore-securitylake =
    buildTypesAiobotocorePackage "securitylake" "2.15.2"
      "sha256-DwJsoRR3NZEVQ3uvploTO3eRqGvMpET96CJm5Gx2kDc=";

  types-aiobotocore-serverlessrepo =
    buildTypesAiobotocorePackage "serverlessrepo" "2.15.2"
      "sha256-X0o4l4pcJmVnLkA1huf520RqMEFbkMqqs09ZqlFvl8w=";

  types-aiobotocore-service-quotas =
    buildTypesAiobotocorePackage "service-quotas" "2.15.2"
      "sha256-Pbj9G+3rPMNyJ5Z3wQT4Zvqeb7N2H3ui+9CxcpU1oHU=";

  types-aiobotocore-servicecatalog =
    buildTypesAiobotocorePackage "servicecatalog" "2.15.2"
      "sha256-uSkuoDBkYXzGDBLtIX/4tmfFhRFfiWJGHmz5OpJhLek=";

  types-aiobotocore-servicecatalog-appregistry =
    buildTypesAiobotocorePackage "servicecatalog-appregistry" "2.15.2"
      "sha256-qxjPzRVuya2L2yedaMejt8S0iNQkec0mRteahClNFDQ=";

  types-aiobotocore-servicediscovery =
    buildTypesAiobotocorePackage "servicediscovery" "2.15.2"
      "sha256-CHvjmH7uPYJ1o97k+/u2GRK7/R0BaDfA6nhyJl3I0+U=";

  types-aiobotocore-ses =
    buildTypesAiobotocorePackage "ses" "2.15.2"
      "sha256-3jDEReH8mLWDRDaEBGhXnESbvw5l8OANgl6VnYcbN6I=";

  types-aiobotocore-sesv2 =
    buildTypesAiobotocorePackage "sesv2" "2.15.2"
      "sha256-6NbQYkz04lWokHuhFpq3yY60HkXKKQkdXztNjW3XGcc=";

  types-aiobotocore-shield =
    buildTypesAiobotocorePackage "shield" "2.15.2"
      "sha256-lxGndPfh8XDcj8e8oKydEPcFfzNiSVXHAgv3rxSg11U=";

  types-aiobotocore-signer =
    buildTypesAiobotocorePackage "signer" "2.15.2"
      "sha256-vVkz6+GhJf8J2d/ZTfbTxIVdnWXA/ye/eq4nCtd/Krw=";

  types-aiobotocore-simspaceweaver =
    buildTypesAiobotocorePackage "simspaceweaver" "2.15.2"
      "sha256-JesS1NX79j37T3K2lAaSAoQ3M0SYHgHWW6w5EGkwgoU=";

  types-aiobotocore-sms =
    buildTypesAiobotocorePackage "sms" "2.15.2"
      "sha256-BD4R+N71BtyFQDzCR7e84vovWKkNRagloe5Se/oZJPU=";

  types-aiobotocore-sms-voice =
    buildTypesAiobotocorePackage "sms-voice" "2.15.2"
      "sha256-6UwSaemdRzaFk7fI+W1K7HUQTo93CTuoiQfOtvlroog=";

  types-aiobotocore-snow-device-management =
    buildTypesAiobotocorePackage "snow-device-management" "2.15.2"
      "sha256-8Qt9oOvwGYiDnCNNRzXKGpSF+cxKbQFErROsWS5NQ6o=";

  types-aiobotocore-snowball =
    buildTypesAiobotocorePackage "snowball" "2.15.2"
      "sha256-/NDdsd9AcLcpXAs0tqZ+nHHNJudfxVuYatqJHr9a8oo=";

  types-aiobotocore-sns =
    buildTypesAiobotocorePackage "sns" "2.15.2"
      "sha256-7YRa4LucT1Jl8oujdVYsMw/wnRYSSMaZXMaY9qz4mRQ=";

  types-aiobotocore-sqs =
    buildTypesAiobotocorePackage "sqs" "2.15.2"
      "sha256-6R+AHdVU27iziZvPWMzB3iPNaFYvdQkzfHQAOK+PMtI=";

  types-aiobotocore-ssm =
    buildTypesAiobotocorePackage "ssm" "2.15.2"
      "sha256-6b8jBjW+dhoaoM/xx08mZAh4EndISChOQL+mZZp14Q4=";

  types-aiobotocore-ssm-contacts =
    buildTypesAiobotocorePackage "ssm-contacts" "2.15.2"
      "sha256-JsJoes3hiMJsOK9fMaO/xSSgyNR8W0KqxsW49sQ/qFo=";

  types-aiobotocore-ssm-incidents =
    buildTypesAiobotocorePackage "ssm-incidents" "2.15.2"
      "sha256-TZ2mFVwjA3UGCnyVIOFNG6GSF1tWD+SP03g8CZZdr6c=";

  types-aiobotocore-ssm-sap =
    buildTypesAiobotocorePackage "ssm-sap" "2.15.2"
      "sha256-nJHnIk+XzFLKeNJ3UdM9NslUeJdFhru6cmvvoZUJmTU=";

  types-aiobotocore-sso =
    buildTypesAiobotocorePackage "sso" "2.15.2"
      "sha256-PhoZgQqeNQc3B75O1jIWVNU7lR9uBrJG9GpTfHB1pnI=";

  types-aiobotocore-sso-admin =
    buildTypesAiobotocorePackage "sso-admin" "2.15.2"
      "sha256-+Ofbw3lAiX3RtygG9zfxX3i87NVdYmIHKKxq+7NTHHE=";

  types-aiobotocore-sso-oidc =
    buildTypesAiobotocorePackage "sso-oidc" "2.15.2"
      "sha256-ZhEJ9TSH5zbH0a1ukgxX/XwIKrwxFvh/CF9SOAmAd4o=";

  types-aiobotocore-stepfunctions =
    buildTypesAiobotocorePackage "stepfunctions" "2.15.2"
      "sha256-DN3vboRwssrSolCuKts/35RiQR6jV61+QN7Z8cp2f4Y=";

  types-aiobotocore-storagegateway =
    buildTypesAiobotocorePackage "storagegateway" "2.15.2"
      "sha256-6ahEEQrrvRI90jGON71iTLRatrEoF7ZyG7qJmG3oCsU=";

  types-aiobotocore-sts =
    buildTypesAiobotocorePackage "sts" "2.15.2"
      "sha256-5Ua7GxbzeeX0/8vTxsYgB8jruGv5u16FQ8plGKLMBVw=";

  types-aiobotocore-support =
    buildTypesAiobotocorePackage "support" "2.15.2"
      "sha256-nM+vzI5wv8VRyRUok6GaI77VEBcaxeGikldAAvAIAXw=";

  types-aiobotocore-support-app =
    buildTypesAiobotocorePackage "support-app" "2.15.2"
      "sha256-EhVR5a5O7/XwiRDcIsUS6aZqILArMyxd85XmiNN+M+Y=";

  types-aiobotocore-swf =
    buildTypesAiobotocorePackage "swf" "2.15.2"
      "sha256-/dz5ZVqz6ovntu/O5ON7Gf1o78Nn1FxJOUzcHvwuOwg=";

  types-aiobotocore-synthetics =
    buildTypesAiobotocorePackage "synthetics" "2.15.2"
      "sha256-akHP8h2XxNvHVku5uCTQ3K8HgwWRg9QL1BAQRzQ3eEc=";

  types-aiobotocore-textract =
    buildTypesAiobotocorePackage "textract" "2.15.2"
      "sha256-Wt8E53/j9mi0yJWp/+omVnIBoI5sVMJPgR4BofB+6nM=";

  types-aiobotocore-timestream-query =
    buildTypesAiobotocorePackage "timestream-query" "2.15.2"
      "sha256-7oi/qslTdLXQGVzsucF09PT+A1gyncYXdNoY0aZZwnA=";

  types-aiobotocore-timestream-write =
    buildTypesAiobotocorePackage "timestream-write" "2.15.2"
      "sha256-oOPC3wV2Wutveglu9vd6bNl9MGWxsJhyxn1h3R5h3DU=";

  types-aiobotocore-tnb =
    buildTypesAiobotocorePackage "tnb" "2.15.2"
      "sha256-rxiCacHIc1+JX5Ba+Ft3kaZfxPOuQzDbsK/wxPJi4VA=";

  types-aiobotocore-transcribe =
    buildTypesAiobotocorePackage "transcribe" "2.15.2"
      "sha256-IMJBlNAWIlk0FWLQQ/2Gcyk6ePqicSqOkDvIxuc+yjg=";

  types-aiobotocore-transfer =
    buildTypesAiobotocorePackage "transfer" "2.15.2"
      "sha256-M0bTj75PMhNE4Z1Cw8Mb5qlqN3NFkqyWPMi2T5IHnH0=";

  types-aiobotocore-translate =
    buildTypesAiobotocorePackage "translate" "2.15.2"
      "sha256-OJYflZHEP6xshavrMsdALZ1W7OFGlXTcZ2y7lSZFiiM=";

  types-aiobotocore-verifiedpermissions =
    buildTypesAiobotocorePackage "verifiedpermissions" "2.15.2"
      "sha256-jzG0vdPOF7gtAVdT4zUbQ9on9hGZ0r7Ip3BPJYVFk6I=";

  types-aiobotocore-voice-id =
    buildTypesAiobotocorePackage "voice-id" "2.15.2"
      "sha256-AG6/UuYdeYOjECyemoqB7BrjIDg6OuIbIfdCaSsgc7Y=";

  types-aiobotocore-vpc-lattice =
    buildTypesAiobotocorePackage "vpc-lattice" "2.15.2"
      "sha256-pSrj/6I5X4EAiBGtP/usG8AnDFrExtV7wpCMIYjdmLI=";

  types-aiobotocore-waf =
    buildTypesAiobotocorePackage "waf" "2.15.2"
      "sha256-rdMMNnCkv1+sCL+4lB5ubSWAyPvBrNDuLZcqFAky6kI=";

  types-aiobotocore-waf-regional =
    buildTypesAiobotocorePackage "waf-regional" "2.15.2"
      "sha256-FqUfQlM41v6q5SdlSgzBt/MnK3SiDYdGKpqNnlcKMXQ=";

  types-aiobotocore-wafv2 =
    buildTypesAiobotocorePackage "wafv2" "2.15.2"
      "sha256-wOVJrIL5F7qapff49bWw2NfX3p+fr2KiLyDU0UIKMDg=";

  types-aiobotocore-wellarchitected =
    buildTypesAiobotocorePackage "wellarchitected" "2.15.2"
      "sha256-srXL51+IeqOadPa8TFSA3BZEPQbw51zgsuRTbDJlACw=";

  types-aiobotocore-wisdom =
    buildTypesAiobotocorePackage "wisdom" "2.15.2"
      "sha256-p0KPHHmqy9Jd4tWypg+5AcnEHb0dESwNVC6bPr1VDBc=";

  types-aiobotocore-workdocs =
    buildTypesAiobotocorePackage "workdocs" "2.15.2"
      "sha256-csR9+vedxQbUu16e3fCwSTW4opv2FW7VnNXsfawJGSk=";

  types-aiobotocore-worklink =
    buildTypesAiobotocorePackage "worklink" "2.15.1"
      "sha256-VvuxiybvGaehPqyVUYGO1bbVSQ0OYgk6LbzgoKLHF2c=";

  types-aiobotocore-workmail =
    buildTypesAiobotocorePackage "workmail" "2.15.1"
      "sha256-o2n4u7wgJPSS02LLZe+PLsxdwm5r+0j3VzDFVnR7bGc=";

  types-aiobotocore-workmailmessageflow =
    buildTypesAiobotocorePackage "workmailmessageflow" "2.15.2"
      "sha256-2Rb15SCI1o6OfMuJzWcosZqWZQOs0ZrPGLDy7bdZPPk=";

  types-aiobotocore-workspaces =
    buildTypesAiobotocorePackage "workspaces" "2.15.2"
      "sha256-wQSb23Y6nySclLl9c2MCfiZ81N+GKbYhHcro6zBVtNo=";

  types-aiobotocore-workspaces-web =
    buildTypesAiobotocorePackage "workspaces-web" "2.15.2"
      "sha256-oFljA4OPlPF4q9xMMxhtv2/t5FQcwUeGdBC3ueGCnKA=";

  types-aiobotocore-xray =
    buildTypesAiobotocorePackage "xray" "2.15.2"
      "sha256-coVjEy0/Kt0gkLS/MI/r1WpXvbJJeCMfGUfCYH7SNPY=";
}
