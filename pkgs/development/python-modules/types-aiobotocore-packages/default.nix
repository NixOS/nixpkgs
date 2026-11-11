{
  lib,
  stdenv,
  aiobotocore,
  boto3,
  botocore,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

let
  toUnderscore = str: builtins.replaceStrings [ "-" ] [ "_" ] str;
  buildTypesAiobotocorePackage =
    serviceName: version: hash:
    buildPythonPackage (finalAttrs: {
      pname = "types-aiobotocore-${serviceName}";
      inherit version;
      pyproject = true;

      oldStylePackages = [
        "gamesparks"
        "iot-roborunner"
        "macie"
      ];

      src = fetchPypi {
        pname =
          if builtins.elem serviceName finalAttrs.oldStylePackages then
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
      ];

      # Module has no tests
      doCheck = false;

      pythonImportsCheck = [ "types_aiobotocore_${toUnderscore serviceName}" ];

      meta = {
        description = "Type annotations for aiobotocore ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = lib.licenses.mit;
        maintainers = [ ];
      };
    });
in
{
  types-aiobotocore-accessanalyzer =
    buildTypesAiobotocorePackage "accessanalyzer" "3.10.0"
      "sha256-O8LwDGfDkvRDgawu/9bMOKOmskhnAQNMWt1H8o2qyh8=";

  types-aiobotocore-account =
    buildTypesAiobotocorePackage "account" "3.10.0"
      "sha256-KyFJWoJnydwR3+zihZVZMF10Tn+w9RcRDQokxwYW+qc=";

  types-aiobotocore-acm =
    buildTypesAiobotocorePackage "acm" "3.10.0"
      "sha256-urTve2IcF+QKveFu564SUQe4vkslo5Lfpjq8g74NDOM=";

  types-aiobotocore-acm-pca =
    buildTypesAiobotocorePackage "acm-pca" "3.10.0"
      "sha256-SsEEd882yuokyCy+A/2BcutxgaiJ55UBbvlZGcRLDPk=";

  types-aiobotocore-aiops =
    buildTypesAiobotocorePackage "aiops" "3.10.0"
      "sha256-GoopPp6xpqO/yJLByduuyJ6yib2TmfG0joIKdv1J1UI=";

  types-aiobotocore-alexaforbusiness =
    buildTypesAiobotocorePackage "alexaforbusiness" "2.13.0"
      "sha256-+w/InoQR2aZ5prieGhgEEp7auBiSSghG5zIIHY5Kyao=";

  types-aiobotocore-amp =
    buildTypesAiobotocorePackage "amp" "3.10.0"
      "sha256-wkqYnfO1zFD9wr7DYhZOKMWgZIU2umx5CCT7LxY+95w=";

  types-aiobotocore-amplify =
    buildTypesAiobotocorePackage "amplify" "3.10.0"
      "sha256-++AnDMi012T8oNv5iloRObw5IdEJNwvGjFeicMwVAFk=";

  types-aiobotocore-amplifybackend =
    buildTypesAiobotocorePackage "amplifybackend" "3.10.0"
      "sha256-isNVS+GU34E67z5pKG0eNt1Wp62NImwet+4TiaOS30U=";

  types-aiobotocore-amplifyuibuilder =
    buildTypesAiobotocorePackage "amplifyuibuilder" "3.10.0"
      "sha256-zCR0nV+Fs7oySk8Ixp9Z5QHjWVHpgT1v/OIib5Z7yhg=";

  types-aiobotocore-apigateway =
    buildTypesAiobotocorePackage "apigateway" "3.10.0"
      "sha256-Jk4kz5QJIKgja+/DyoJTJAwlVyIEKfiF2orl61Mqa88=";

  types-aiobotocore-apigatewaymanagementapi =
    buildTypesAiobotocorePackage "apigatewaymanagementapi" "3.10.0"
      "sha256-Jp3wt68A76/CG1zCQZbGuovbl+73YbtUTJntiqJp5ag=";

  types-aiobotocore-apigatewayv2 =
    buildTypesAiobotocorePackage "apigatewayv2" "3.10.0"
      "sha256-xcfKBMJGSDQ+hp767Gif9ntCTeLgsJXqRar5JPRejoY=";

  types-aiobotocore-appconfig =
    buildTypesAiobotocorePackage "appconfig" "3.10.0"
      "sha256-5PQjh6WzGcxYaYl9kqJ/+DkOv2eEzUwctREzm3ZJsyI=";

  types-aiobotocore-appconfigdata =
    buildTypesAiobotocorePackage "appconfigdata" "3.10.0"
      "sha256-wVnpKVS7Najxgu176kxMLa0SnaiHb5mpoqDf0wZNfDA=";

  types-aiobotocore-appfabric =
    buildTypesAiobotocorePackage "appfabric" "3.10.0"
      "sha256-+W2t9duWZtPceD/N+En9QiwhzAjJPYYmxpGFFXu106A=";

  types-aiobotocore-appflow =
    buildTypesAiobotocorePackage "appflow" "3.10.0"
      "sha256-qIypTrJdZOakUheOm7cIRviMQ4J2ofcpERzyM5WcaIE=";

  types-aiobotocore-appintegrations =
    buildTypesAiobotocorePackage "appintegrations" "3.10.0"
      "sha256-yeg7P/vc3suXAeyWzGYzkY6klIFS3Y2ilGNvJUtyWas=";

  types-aiobotocore-application-autoscaling =
    buildTypesAiobotocorePackage "application-autoscaling" "3.10.0"
      "sha256-8HPMBEBq9WRXrx9ZX3ltM8Mr+iRj83J4m6vJp6chbno=";

  types-aiobotocore-application-insights =
    buildTypesAiobotocorePackage "application-insights" "3.10.0"
      "sha256-ENe49j4p5NVjDeqGtoHSfy99QjwR29cgHF5wzxPj24k=";

  types-aiobotocore-applicationcostprofiler =
    buildTypesAiobotocorePackage "applicationcostprofiler" "3.10.0"
      "sha256-WrIJ0hlwdlsSFl0aqsBkr6DHeCqOyolFLBx2PrHU5Rg=";

  types-aiobotocore-appmesh =
    buildTypesAiobotocorePackage "appmesh" "3.10.0"
      "sha256-7pRunxHehlEf1IcPz30wpuW/5m7kTzs6eNjJm6GlPuI=";

  types-aiobotocore-apprunner =
    buildTypesAiobotocorePackage "apprunner" "3.10.0"
      "sha256-m00bt5+zCR2H9omkIHiyHmJm1M0pATCCSqHqVYWeh0o=";

  types-aiobotocore-appstream =
    buildTypesAiobotocorePackage "appstream" "3.10.0"
      "sha256-WUdDYZI5fFP8eT2zyZFcO8FCQzx6/3U8cJcZLKUMsOA=";

  types-aiobotocore-appsync =
    buildTypesAiobotocorePackage "appsync" "3.10.0"
      "sha256-xPs4imzTnDMHpsdJg94PG5h66CTn1RQKHpBYEmJs36c=";

  types-aiobotocore-arc-zonal-shift =
    buildTypesAiobotocorePackage "arc-zonal-shift" "3.10.0"
      "sha256-5+hmm48VrAUWEyCnGN29Is7rB3vgG43so+pSAy9xS7g=";

  types-aiobotocore-athena =
    buildTypesAiobotocorePackage "athena" "3.10.0"
      "sha256-CSMX8D6G3Q4bTZkl36k0jDA+/OHfD9bNkwUSj3P6g9c=";

  types-aiobotocore-auditmanager =
    buildTypesAiobotocorePackage "auditmanager" "3.10.0"
      "sha256-/1XvNcp4kLBTdkrjHKIFmLEl6HAy0Mi+ZNj4B6FSqww=";

  types-aiobotocore-autoscaling =
    buildTypesAiobotocorePackage "autoscaling" "3.10.0"
      "sha256-+HwZPwBnMjjR5iGYSyvAmWnSPw+4ZTHcXxlN3EINUfM=";

  types-aiobotocore-autoscaling-plans =
    buildTypesAiobotocorePackage "autoscaling-plans" "3.10.0"
      "sha256-y/TD5ViNDLBJT2v1Pqy7wMT3NZcpKfANmpF2H3g9HMA=";

  types-aiobotocore-backup =
    buildTypesAiobotocorePackage "backup" "3.10.0"
      "sha256-ZZFqVJYg3HUkzn6UrVy0mvsQTDq2fXt2YpDTROSbVCU=";

  types-aiobotocore-backup-gateway =
    buildTypesAiobotocorePackage "backup-gateway" "3.10.0"
      "sha256-inWFX75fJWZxNFrLXmH5SKJv3P8UDvnpqxSBiPxvdbY=";

  types-aiobotocore-backupstorage =
    buildTypesAiobotocorePackage "backupstorage" "2.13.0"
      "sha256-YUKtBdBrdwL2yqDqOovvzDPbcv/sD8JLRnKz3Oh7iSU=";

  types-aiobotocore-batch =
    buildTypesAiobotocorePackage "batch" "3.10.0"
      "sha256-lB9Q2e8amUeg2IbtSsG/11O/0PGHQapfQ8tjAhk6tJA=";

  types-aiobotocore-billingconductor =
    buildTypesAiobotocorePackage "billingconductor" "3.10.0"
      "sha256-j0lizj4MK0ELgW3/7q9yHJD11GJfNAKTwhn1rtPW4n4=";

  types-aiobotocore-braket =
    buildTypesAiobotocorePackage "braket" "3.10.0"
      "sha256-Vvam+SkxzsQWssiREgfnR4Z55s7JQn1Qf7z3T9q29nM=";

  types-aiobotocore-budgets =
    buildTypesAiobotocorePackage "budgets" "3.10.0"
      "sha256-AT45/E2YXWHXTgLrN6g+99cBQ8TXV9FJF392BS627Ko=";

  types-aiobotocore-ce =
    buildTypesAiobotocorePackage "ce" "3.10.0"
      "sha256-scZNp8aNl0qG5Rr6i54CoRmrGOnDuQYvZsOmBhTfSmg=";

  types-aiobotocore-chime =
    buildTypesAiobotocorePackage "chime" "3.10.0"
      "sha256-eaFWe3DHvZuuybFHgGSzDJSDb9XS4BQEGQZPDaLEbQM=";

  types-aiobotocore-chime-sdk-identity =
    buildTypesAiobotocorePackage "chime-sdk-identity" "3.10.0"
      "sha256-bgm+Kyj8kk82YhBs1Xst50xVwULRkAfyqWTtH1meLdU=";

  types-aiobotocore-chime-sdk-media-pipelines =
    buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "3.10.0"
      "sha256-Jm3m8YAHbqTRg2Bt0AenxBO1U6w7176CJX0nUeBIloQ=";

  types-aiobotocore-chime-sdk-meetings =
    buildTypesAiobotocorePackage "chime-sdk-meetings" "3.10.0"
      "sha256-3WXKXDtHlqW3Rg0pOrxk7ksm7jHtRDlXYs7pqYfmBvs=";

  types-aiobotocore-chime-sdk-messaging =
    buildTypesAiobotocorePackage "chime-sdk-messaging" "3.10.0"
      "sha256-MjhoVksO2xwYgKv1SgWnQgvV1uqPT0VxQpaNqRanP3E=";

  types-aiobotocore-chime-sdk-voice =
    buildTypesAiobotocorePackage "chime-sdk-voice" "3.10.0"
      "sha256-blthQR3wQjBmoYNQ0i984KK0iM+LqEKAdExr75EnA8k=";

  types-aiobotocore-cleanrooms =
    buildTypesAiobotocorePackage "cleanrooms" "3.10.0"
      "sha256-yiJnAxNFzAvgffF3le8gWxWCcdlPzIlHbWRl+ddGm6k=";

  types-aiobotocore-cloud9 =
    buildTypesAiobotocorePackage "cloud9" "3.10.0"
      "sha256-Sz9xUiO78HZmJ1r64hIltnkkJ0nOMbIOGav5W5YB+CI=";

  types-aiobotocore-cloudcontrol =
    buildTypesAiobotocorePackage "cloudcontrol" "3.10.0"
      "sha256-qBMFny8VqxMUzCZmX43/MaiqJAN1nmffvTHpb/4jqEg=";

  types-aiobotocore-clouddirectory =
    buildTypesAiobotocorePackage "clouddirectory" "3.10.0"
      "sha256-dIxhWEXnLmW7X+zOkLdJ4Uiag0ytysEKARfBUQXYLOc=";

  types-aiobotocore-cloudformation =
    buildTypesAiobotocorePackage "cloudformation" "3.10.0"
      "sha256-Ej7xfCS4XR5WGBdIhJod6Mbq3KH830tyyg7tkFYQ9QU=";

  types-aiobotocore-cloudfront =
    buildTypesAiobotocorePackage "cloudfront" "3.10.0"
      "sha256-OLL0nNnYwTrPGyW7OMR5ojW9NT1FXkLtRzkWsL5jV6A=";

  types-aiobotocore-cloudhsm =
    buildTypesAiobotocorePackage "cloudhsm" "3.10.0"
      "sha256-vkXbb9l/9f5P+L0Z35H+ZWGYgGv7VHV1TEViesWbQkA=";

  types-aiobotocore-cloudhsmv2 =
    buildTypesAiobotocorePackage "cloudhsmv2" "3.10.0"
      "sha256-pc97vQth4yOL6gNxmIf0V6F5MPv2rKsTNA3kif7RjF4=";

  types-aiobotocore-cloudsearch =
    buildTypesAiobotocorePackage "cloudsearch" "3.10.0"
      "sha256-sX27c8UJoo4HVAcQ9VrF4RWl7/mjhsj1K0FhVDYzaHQ=";

  types-aiobotocore-cloudsearchdomain =
    buildTypesAiobotocorePackage "cloudsearchdomain" "3.10.0"
      "sha256-dKK1bUAHCMB1egWT7iNTtv1qqUWaIWAghScszildhL4=";

  types-aiobotocore-cloudtrail =
    buildTypesAiobotocorePackage "cloudtrail" "3.10.0"
      "sha256-fN/dp8l61ctxHMEEqJTKlYj0UB5n8NxLb1IEahBRqtk=";

  types-aiobotocore-cloudtrail-data =
    buildTypesAiobotocorePackage "cloudtrail-data" "3.10.0"
      "sha256-lbd94NNHpYMPJPqogqj70ZilMfCSNfYSRmajDSrFI10=";

  types-aiobotocore-cloudwatch =
    buildTypesAiobotocorePackage "cloudwatch" "3.10.0"
      "sha256-IeX3Pz/6ATMTLIJ1nR9IoOIylHpsxykiGDAlfliVZBs=";

  types-aiobotocore-codeartifact =
    buildTypesAiobotocorePackage "codeartifact" "3.10.0"
      "sha256-02S4MbLkl7VO4Bv6q/AM+6TvBGOJW/VuoM7yPIL0Vcw=";

  types-aiobotocore-codebuild =
    buildTypesAiobotocorePackage "codebuild" "3.10.0"
      "sha256-+XViLgWY/qGVbPdy7WsGnCk0VrizDK5hUKxye2ZMboE=";

  types-aiobotocore-codecatalyst =
    buildTypesAiobotocorePackage "codecatalyst" "3.10.0"
      "sha256-mIxqnspuJDjbH81FCaGOmdAN8WWRLC91xMDApH9NMAw=";

  types-aiobotocore-codecommit =
    buildTypesAiobotocorePackage "codecommit" "3.10.0"
      "sha256-q2o6o4UN+fF3euZ1fxzkzRokHyFLcnuUVST1yvnElro=";

  types-aiobotocore-codeconnections =
    buildTypesAiobotocorePackage "codeconnections" "3.10.0"
      "sha256-IeJPgPInjU7pYKpPdGeUQumfZBh56QkzXqnZvK85LqI=";

  types-aiobotocore-codedeploy =
    buildTypesAiobotocorePackage "codedeploy" "3.10.0"
      "sha256-yOr/s4bAgDcZLwal3qQuSiL7kZ7rcQmi0fmaBposD8U=";

  types-aiobotocore-codeguru-reviewer =
    buildTypesAiobotocorePackage "codeguru-reviewer" "3.10.0"
      "sha256-pVSitdH0n9EtLrVIGuQGGeVkYr26CqleGuGGzqlxB+I=";

  types-aiobotocore-codeguru-security =
    buildTypesAiobotocorePackage "codeguru-security" "3.10.0"
      "sha256-fUScZBNM2ytw7SIlZctu1el/SCsWM1fM73H6M+iFzDk=";

  types-aiobotocore-codeguruprofiler =
    buildTypesAiobotocorePackage "codeguruprofiler" "3.10.0"
      "sha256-9kdL+OiTgtcEucEIaFondcamamldqYAPki9q7gt9LTQ=";

  types-aiobotocore-codepipeline =
    buildTypesAiobotocorePackage "codepipeline" "3.10.0"
      "sha256-kYHxTtA4K2cTgj+HYwBeztgLuj1puBhrK0Jv1csH34M=";

  types-aiobotocore-codestar =
    buildTypesAiobotocorePackage "codestar" "2.13.3"
      "sha256-Z1ewx2RjmxbOQZ7wXaN54PVOuRs6LP3rMpsrVTacwjo=";

  types-aiobotocore-codestar-connections =
    buildTypesAiobotocorePackage "codestar-connections" "3.10.0"
      "sha256-HW5fM+UCzCK6gsCasIpvgt/iJASo3/rMtoOx8hjQ4KQ=";

  types-aiobotocore-codestar-notifications =
    buildTypesAiobotocorePackage "codestar-notifications" "3.10.0"
      "sha256-2dn1Pa9LKg6h736eM8BitR1lyabK7pPSdxkx2gYWpI4=";

  types-aiobotocore-cognito-identity =
    buildTypesAiobotocorePackage "cognito-identity" "3.10.0"
      "sha256-+t5pIiYwOapNdZRlroAyRgs+riOjDi+7NvYMeSWNU6o=";

  types-aiobotocore-cognito-idp =
    buildTypesAiobotocorePackage "cognito-idp" "3.10.0"
      "sha256-V8nP5WAOCM2gwXUsCc+cPXUXDlq6UN7CgAVGYPubKZ8=";

  types-aiobotocore-cognito-sync =
    buildTypesAiobotocorePackage "cognito-sync" "3.10.0"
      "sha256-oAImT9c/QtMbLg/cuW1w0ZkyN5ArNnqF4M2nNznT/AI=";

  types-aiobotocore-comprehend =
    buildTypesAiobotocorePackage "comprehend" "3.10.0"
      "sha256-rrZBu7j41JH69efR8NkWuJ5tmBMJZ4FA1oanzKmACkw=";

  types-aiobotocore-comprehendmedical =
    buildTypesAiobotocorePackage "comprehendmedical" "3.10.0"
      "sha256-bLG6M5pX42A7iLiBlUy+aDJY0fBLSPh0+o8MFVfNdzs=";

  types-aiobotocore-compute-optimizer =
    buildTypesAiobotocorePackage "compute-optimizer" "3.10.0"
      "sha256-+tGGvqC9APguBzjkxdLui0KcmAKQPPRsZnc4vdasSpg=";

  types-aiobotocore-config =
    buildTypesAiobotocorePackage "config" "3.10.0"
      "sha256-6cjOflXpQZx3sezk1KtwMVtSEm+mFprf1Sjg20MBJSU=";

  types-aiobotocore-connect =
    buildTypesAiobotocorePackage "connect" "3.10.0"
      "sha256-COp6VdcdmKR8ey1Wr+08TFKicMtpaE+3GVJrtg6iRmw=";

  types-aiobotocore-connect-contact-lens =
    buildTypesAiobotocorePackage "connect-contact-lens" "3.10.0"
      "sha256-jiq7p4H9PHeKAJa0ieOx5mm8glHWYMdGjV3m9maPpcw=";

  types-aiobotocore-connectcampaigns =
    buildTypesAiobotocorePackage "connectcampaigns" "3.10.0"
      "sha256-pFpJ9WpumZWGucLIomyleaBeapJWhMYvoWVTAsZkc/Q=";

  types-aiobotocore-connectcases =
    buildTypesAiobotocorePackage "connectcases" "3.10.0"
      "sha256-HY4yAOs8rszlyBEvAoRe4GXgFRC2EEXUjIaCXBnz5DY=";

  types-aiobotocore-connectparticipant =
    buildTypesAiobotocorePackage "connectparticipant" "3.10.0"
      "sha256-9CcO4RK7fOQF1M+TgT/Nz0IWwuuoBjMU9bxhwph1WBg=";

  types-aiobotocore-controltower =
    buildTypesAiobotocorePackage "controltower" "3.10.0"
      "sha256-qy9qAfWqMeMbg9iJmd7clH29wG8E7Xb14y151WPUlLY=";

  types-aiobotocore-cur =
    buildTypesAiobotocorePackage "cur" "3.10.0"
      "sha256-lHUOcBMfei2j0ubtm3cEh7gZOi8cXCKpaETE2LTWqDs=";

  types-aiobotocore-customer-profiles =
    buildTypesAiobotocorePackage "customer-profiles" "3.10.0"
      "sha256-HRZznBns3ieyvf6D4NhwLHjELC/ax8F3Le8QxJDZaXU=";

  types-aiobotocore-databrew =
    buildTypesAiobotocorePackage "databrew" "3.10.0"
      "sha256-PQB8arwPw9qqo8PWybtMdDugrQIqPR81Jrqdm0FiIFE=";

  types-aiobotocore-dataexchange =
    buildTypesAiobotocorePackage "dataexchange" "3.10.0"
      "sha256-yFbBtiiGaGVP3oFiI7vxXcA9Oe1gE8Td9Jybx5rXI7Q=";

  types-aiobotocore-datapipeline =
    buildTypesAiobotocorePackage "datapipeline" "3.10.0"
      "sha256-LZYaWS/uRz4dAFVx4EasrDGpnKtumcizUt/8oBFLomw=";

  types-aiobotocore-datasync =
    buildTypesAiobotocorePackage "datasync" "3.10.0"
      "sha256-i3JiNQcYVkfZsEkXZvPalNFyZDym3l/VM5lZO6d26O8=";

  types-aiobotocore-dax =
    buildTypesAiobotocorePackage "dax" "3.10.0"
      "sha256-iEz7uMD7IqsJgZWhCNmKCQ4OgpaCIIT8GydFdEKVxYg=";

  types-aiobotocore-detective =
    buildTypesAiobotocorePackage "detective" "3.10.0"
      "sha256-K0rwjn/yQKzxZixfOi0UpH0OHz139t2my7dciI4kGmM=";

  types-aiobotocore-devicefarm =
    buildTypesAiobotocorePackage "devicefarm" "3.10.0"
      "sha256-ta9mj6nBU7MX1GtDqOnErWTJPaV9oqht6sA+ci+Bt04=";

  types-aiobotocore-devops-guru =
    buildTypesAiobotocorePackage "devops-guru" "3.10.0"
      "sha256-Pjpl9ZA56zAa1Oelb1ULdC0AXjDRW2rtVLY0Wi/HVbg=";

  types-aiobotocore-directconnect =
    buildTypesAiobotocorePackage "directconnect" "3.10.0"
      "sha256-+CmZxEAwuY5C2Ik6vW5xWncqhfFTy+4Olt+0HTLzSEs=";

  types-aiobotocore-discovery =
    buildTypesAiobotocorePackage "discovery" "3.10.0"
      "sha256-JM2iIbmG0zdQp6sLek2KcsGAVAdEsUlbCm3XPIGLXSo=";

  types-aiobotocore-dlm =
    buildTypesAiobotocorePackage "dlm" "3.10.0"
      "sha256-C+rVRqNNbqouF6UjCI1GBUBNCqVi52Mmt+7rpcdUwMI=";

  types-aiobotocore-dms =
    buildTypesAiobotocorePackage "dms" "3.10.0"
      "sha256-dvHfxpCO2qJAqmNC0fmA8mVDjWzRk4+UVUgvZEJCps0=";

  types-aiobotocore-docdb =
    buildTypesAiobotocorePackage "docdb" "3.10.0"
      "sha256-n9u3PWjLP0cCDszUQZnh4n4p1NeWQsSKa7USKFE2ptg=";

  types-aiobotocore-docdb-elastic =
    buildTypesAiobotocorePackage "docdb-elastic" "3.10.0"
      "sha256-38fqR939t7x8ofVtyoymGGVOGMEpdz3e7wyibDVwzFk=";

  types-aiobotocore-drs =
    buildTypesAiobotocorePackage "drs" "3.10.0"
      "sha256-Fg7SDuc7LCG6zU98Mrt3JwuzThSnO9yaJ2yPrfgkmtg=";

  types-aiobotocore-ds =
    buildTypesAiobotocorePackage "ds" "3.10.0"
      "sha256-YTL0ftAMIA3YR8aZYc7k4JEhzMFVprXlfV6wIY8FzD0=";

  types-aiobotocore-dynamodb =
    buildTypesAiobotocorePackage "dynamodb" "3.10.0"
      "sha256-7429XcPhCoF9MLZh7AK5FAWpRDV39PCg/4OcYRPm8BY=";

  types-aiobotocore-dynamodbstreams =
    buildTypesAiobotocorePackage "dynamodbstreams" "3.10.0"
      "sha256-EVVjZH22Qpv3IGHYXF2FBuxElO745OSJleWZt/shsKo=";

  types-aiobotocore-ebs =
    buildTypesAiobotocorePackage "ebs" "3.10.0"
      "sha256-LcabZIcxBAQGFRIdDLHLT5TN0KSn0MvDvvFKABDHJ2o=";

  types-aiobotocore-ec2 =
    buildTypesAiobotocorePackage "ec2" "3.10.0"
      "sha256-JBAayB3r/sD4oc1no54mq9Tc4PGVKkQt3Ww3blU5zZ4=";

  types-aiobotocore-ec2-instance-connect =
    buildTypesAiobotocorePackage "ec2-instance-connect" "3.10.0"
      "sha256-YG8krxwn08lYwPDdnYhS/h3I1BsLronuHEJ+CETQu9Q=";

  types-aiobotocore-ecr =
    buildTypesAiobotocorePackage "ecr" "3.10.0"
      "sha256-3y5YkZ2R3MJREFlmQIkWI6fJCgd05QF13rIm7FQhXSo=";

  types-aiobotocore-ecr-public =
    buildTypesAiobotocorePackage "ecr-public" "3.10.0"
      "sha256-DNN0vZ9nE5vyXYl9SKqwU5LkkhbJpPM8DcJ3lAwk2/Y=";

  types-aiobotocore-ecs =
    buildTypesAiobotocorePackage "ecs" "3.10.0"
      "sha256-gZa+Czmdkm8XFYcQs4550nunPTSzavrjtJv4CR7SHI8=";

  types-aiobotocore-efs =
    buildTypesAiobotocorePackage "efs" "3.10.0"
      "sha256-SYQk79aaTwHO3EEt02ITp07tte3UnKlS3/NCxZUk/mw=";

  types-aiobotocore-eks =
    buildTypesAiobotocorePackage "eks" "3.10.0"
      "sha256-zBamI984bwDjID3PmlazkjpqQpMleOXkTBMII1hfpto=";

  types-aiobotocore-elastic-inference =
    buildTypesAiobotocorePackage "elastic-inference" "2.20.0"
      "sha256-jFSY7JBVjDQi6dCqlX2LG7jxpSKfILv3XWbYidvtGos=";

  types-aiobotocore-elasticache =
    buildTypesAiobotocorePackage "elasticache" "3.10.0"
      "sha256-Ry7RTXu26vs2tvxxPiV7GMkmGwh8GvGQI+6/Im/BmtQ=";

  types-aiobotocore-elasticbeanstalk =
    buildTypesAiobotocorePackage "elasticbeanstalk" "3.10.0"
      "sha256-xC6so12OEAjcI9/4/Lhqx1yfSDLLJpNfCigESGOgnko=";

  types-aiobotocore-elastictranscoder =
    buildTypesAiobotocorePackage "elastictranscoder" "2.25.2"
      "sha256-5t214U60d2kSf8bmUiEkj4OMFf3+SbNRGqLif1Rj28E=";

  types-aiobotocore-elb =
    buildTypesAiobotocorePackage "elb" "3.10.0"
      "sha256-tK461gGGJcA4DGdi8Wp7dsI6C9l9XfXY+P5Q2yklE44=";

  types-aiobotocore-elbv2 =
    buildTypesAiobotocorePackage "elbv2" "3.10.0"
      "sha256-28KUXAEWRp6GOJRQzObmsdPTIODXZeRireB7r3SCRjk=";

  types-aiobotocore-emr =
    buildTypesAiobotocorePackage "emr" "3.10.0"
      "sha256-ww+V1lOtgFYAVvaWwOTEFUW27IqrwC4iYokas+CXu8A=";

  types-aiobotocore-emr-containers =
    buildTypesAiobotocorePackage "emr-containers" "3.10.0"
      "sha256-/+dAhvOWFqxmett/1VZUIo3jna7aAVTppKw1VLw1Rl8=";

  types-aiobotocore-emr-serverless =
    buildTypesAiobotocorePackage "emr-serverless" "3.10.0"
      "sha256-7dzi/se7NsP3DxOq9ByVlK1A8A3Qpey6j2fVZScBXbY=";

  types-aiobotocore-entityresolution =
    buildTypesAiobotocorePackage "entityresolution" "3.10.0"
      "sha256-3Vd7IqB1lpkBrdCaJN2RLGil5aWlXgQ0MUxxIi1Bwsg=";

  types-aiobotocore-es =
    buildTypesAiobotocorePackage "es" "3.10.0"
      "sha256-+Hpy+Mv386Gwp4al9svjVed2L4CJbUwsj1Ui1o9q8gY=";

  types-aiobotocore-events =
    buildTypesAiobotocorePackage "events" "3.10.0"
      "sha256-fWut2jZvK0JPPfEbvXvVIlDLyYF9eY60ZD/kBh9cO+0=";

  types-aiobotocore-evidently =
    buildTypesAiobotocorePackage "evidently" "3.1.1"
      "sha256-g+XQEgqqZul8kOg0kstdYMvw2tu6zhC9GZGgs7WH3Mo=";

  types-aiobotocore-finspace =
    buildTypesAiobotocorePackage "finspace" "3.9.2"
      "sha256-GWLW19D0uyn53RsFimOg86G4P11TShnznY+z4e+vVeo=";

  types-aiobotocore-finspace-data =
    buildTypesAiobotocorePackage "finspace-data" "3.9.2"
      "sha256-bX8tCfRfEhQPOcgs+JBZQjVqWWNClOOiFSOlj/uph70=";

  types-aiobotocore-firehose =
    buildTypesAiobotocorePackage "firehose" "3.10.0"
      "sha256-xKoRQIwkt0kGKEazIeMEgAuXUCmWoC8hjNHb4f4OBfE=";

  types-aiobotocore-fis =
    buildTypesAiobotocorePackage "fis" "3.10.0"
      "sha256-1vWe8HqaARDzpnyP9cglsnYfU2+G4S0KPVp0MpKKlKQ=";

  types-aiobotocore-fms =
    buildTypesAiobotocorePackage "fms" "3.10.0"
      "sha256-L/WkYZEgNcaOs4NM/jvCKaWOi54C2J0B8fov7CKVKpE=";

  types-aiobotocore-forecast =
    buildTypesAiobotocorePackage "forecast" "3.10.0"
      "sha256-qOFlgRwkC3KMmqd9nvZrcTvfFZe7n9p7bdG+/z39TJ0=";

  types-aiobotocore-forecastquery =
    buildTypesAiobotocorePackage "forecastquery" "3.10.0"
      "sha256-bIM8CDLCeTru/RMd54APNjmEayGj9o+DoyozUt8iE6E=";

  types-aiobotocore-frauddetector =
    buildTypesAiobotocorePackage "frauddetector" "3.10.0"
      "sha256-pa3aCqnAClFU7dTFrDy3kaOU5oMNOPRiOw4hLcdxVBc=";

  types-aiobotocore-freetier =
    buildTypesAiobotocorePackage "freetier" "3.10.0"
      "sha256-iAmEUcHUChO2/nP6it1lG0dXIab2RknBLSzFqP9QPVc=";

  types-aiobotocore-fsx =
    buildTypesAiobotocorePackage "fsx" "3.10.0"
      "sha256-WGaXvVDp67ydmUsPYxyeMfLlG/NCe7ubcZBC/Yz5E6w=";

  types-aiobotocore-gamelift =
    buildTypesAiobotocorePackage "gamelift" "3.10.0"
      "sha256-1SihC/kSOvVPwHg3VNXSo25oUsHOkPoakQ49N8HrrQk=";

  types-aiobotocore-gamesparks =
    buildTypesAiobotocorePackage "gamesparks" "2.7.0"
      "sha256-oVbKtuLMPpCQcZYx/cH1Dqjv/t6/uXsveflfFVqfN+8=";

  types-aiobotocore-glacier =
    buildTypesAiobotocorePackage "glacier" "3.10.0"
      "sha256-RuXxIF2jzk0rFDU/QlfMrG+m+Q3gbuLF5ALzlO5IuBI=";

  types-aiobotocore-globalaccelerator =
    buildTypesAiobotocorePackage "globalaccelerator" "3.10.0"
      "sha256-bvaof25qtAx13ajR3qsfSFWucO9SYkCTBi5dD9LzzO8=";

  types-aiobotocore-glue =
    buildTypesAiobotocorePackage "glue" "3.10.0"
      "sha256-VHnjf/a3Qr75u/X1Si+bVUxOlAthfwggR/q/8phTMPo=";

  types-aiobotocore-grafana =
    buildTypesAiobotocorePackage "grafana" "3.10.0"
      "sha256-zUZjR2eST+qp3NwlbGLGBJfjcBfSOee37RR8PaiNh2c=";

  types-aiobotocore-greengrass =
    buildTypesAiobotocorePackage "greengrass" "3.10.0"
      "sha256-HdJla/APHDnEBENUfGQkOOdHOHgm6D9Hwb4hK3VfVz8=";

  types-aiobotocore-greengrassv2 =
    buildTypesAiobotocorePackage "greengrassv2" "3.10.0"
      "sha256-rnilUXn9hvbcUQimlvJBJiWJHOOBIGVDQEpW11GMrDo=";

  types-aiobotocore-groundstation =
    buildTypesAiobotocorePackage "groundstation" "3.10.0"
      "sha256-ZZHOMShXtVLpy2mId/rQn22GBiWOgDnE7d+NVtXaPrA=";

  types-aiobotocore-guardduty =
    buildTypesAiobotocorePackage "guardduty" "3.10.0"
      "sha256-H3CL+CIEgmhlF2qS6z2fN4hT0Ky15GraeZM7CR34wmw=";

  types-aiobotocore-health =
    buildTypesAiobotocorePackage "health" "3.10.0"
      "sha256-NEyiFPT9jN2EzHQpf0I2VBogSfalkpRz/4KBut0Ayak=";

  types-aiobotocore-healthlake =
    buildTypesAiobotocorePackage "healthlake" "3.10.0"
      "sha256-+i4GAfxzvxDbo8p3zfi0Ooszwv80GeVlnvFnM+JpP84=";

  types-aiobotocore-honeycode =
    buildTypesAiobotocorePackage "honeycode" "2.13.0"
      "sha256-DeeheoQeFEcDH21DSNs2kSR1rjnPLtTgz0yNCFnE+Io=";

  types-aiobotocore-iam =
    buildTypesAiobotocorePackage "iam" "3.10.0"
      "sha256-laEO7F5xtOVCRrHTDtk3pcLeVgo++vJN75Veh1vchfc=";

  types-aiobotocore-identitystore =
    buildTypesAiobotocorePackage "identitystore" "3.10.0"
      "sha256-I13s9A/V9laD9hKulDvI4z7WZZeOtW84p/3Fjd4x6Kc=";

  types-aiobotocore-imagebuilder =
    buildTypesAiobotocorePackage "imagebuilder" "3.10.0"
      "sha256-wiropq6AAmTZFomp0epkbdd72jrQ5ifDfFf9MmYqmQI=";

  types-aiobotocore-importexport =
    buildTypesAiobotocorePackage "importexport" "3.10.0"
      "sha256-mMNNB/bbHZT+Y0MF7nuOZmIZGOYDA51HtB4QMTU7WvU=";

  types-aiobotocore-inspector =
    buildTypesAiobotocorePackage "inspector" "3.10.0"
      "sha256-mmbfQAO/kc9g+v6+K+BD3TIS3IHR/Lm14esgwA92WCc=";

  types-aiobotocore-inspector2 =
    buildTypesAiobotocorePackage "inspector2" "3.10.0"
      "sha256-7C8FU26ncuRThlRojSNWNB15Xq57WSrL9TAp9n8wKT4=";

  types-aiobotocore-internetmonitor =
    buildTypesAiobotocorePackage "internetmonitor" "3.10.0"
      "sha256-RKCrNPIuXToLhQWM4DvTv/Yjq40/8DE7KKnaRiH1TZ8=";

  types-aiobotocore-iot =
    buildTypesAiobotocorePackage "iot" "3.10.0"
      "sha256-H1kfrS8Jps29hZUCcEjy3Rj66zJDfaB4ZbCacJpPwuk=";

  types-aiobotocore-iot-data =
    buildTypesAiobotocorePackage "iot-data" "3.10.0"
      "sha256-6Maj+0Ddl573221dEWz4gIJXHQzudPSTvs+9urb0pHE=";

  types-aiobotocore-iot-jobs-data =
    buildTypesAiobotocorePackage "iot-jobs-data" "3.10.0"
      "sha256-vZ9IE7K7FI97z9nvf7r1K1P/6loTPe6FhRlIK4UGv6s=";

  types-aiobotocore-iot-roborunner =
    buildTypesAiobotocorePackage "iot-roborunner" "2.12.2"
      "sha256-O/nGvYfUibI4EvHgONtkYHFv/dZSpHCehXjietPiMJo=";

  types-aiobotocore-iot1click-devices =
    buildTypesAiobotocorePackage "iot1click-devices" "2.16.1"
      "sha256-gnQZJMw+Q37B3qu1eYDNxYdEyxNRRZlqAsa4OgZbb40=";

  types-aiobotocore-iot1click-projects =
    buildTypesAiobotocorePackage "iot1click-projects" "2.16.1"
      "sha256-qK5dPunPAbC7xIramYINSda50Zum6yQ4n2BfuOgLC58=";

  types-aiobotocore-iotanalytics =
    buildTypesAiobotocorePackage "iotanalytics" "3.1.1"
      "sha256-Yf1vvasgtUxFiEfSrlPq0Q2yhbAOGyRATzid+qYjlj8=";

  types-aiobotocore-iotdeviceadvisor =
    buildTypesAiobotocorePackage "iotdeviceadvisor" "3.10.0"
      "sha256-LJhoqtkKAyC8ykrTOCfGhlIcyrebYrL4Kl4rEuq5IFU=";

  types-aiobotocore-iotevents =
    buildTypesAiobotocorePackage "iotevents" "3.7.0"
      "sha256-isYjEnViFGsgtRDb3Y2i9vTCjqDcB88rM8JmxhpxIII=";

  types-aiobotocore-iotevents-data =
    buildTypesAiobotocorePackage "iotevents-data" "3.7.0"
      "sha256-FZZowHBNWFF3pWDNZIG12vR9NbWfWNWxt+IJvZYlp3Y=";

  types-aiobotocore-iotfleethub =
    buildTypesAiobotocorePackage "iotfleethub" "2.24.2"
      "sha256-WzdCGMVRCl8x+UswlyApMYMYT3Rvtng0ID2YyV08NzA=";

  types-aiobotocore-iotfleetwise =
    buildTypesAiobotocorePackage "iotfleetwise" "3.10.0"
      "sha256-k8jfVBQw8qTXI/mk/y9aMEAm2Q65nYVMrEK4IIubpPQ=";

  types-aiobotocore-iotsecuretunneling =
    buildTypesAiobotocorePackage "iotsecuretunneling" "3.10.0"
      "sha256-FNJf9sao3XC1lmu8o6Jvc/Sya0TXyOp/Rb2AmLtquk8=";

  types-aiobotocore-iotsitewise =
    buildTypesAiobotocorePackage "iotsitewise" "3.10.0"
      "sha256-+n7UOPepQuefY38SxA8bQuIbQhDAcW4l0Y2JSoPvvSY=";

  types-aiobotocore-iotthingsgraph =
    buildTypesAiobotocorePackage "iotthingsgraph" "3.10.0"
      "sha256-caVJ3lqnlY6IIKG3GJYWYyII1O1oo/nAQrTersK0oq0=";

  types-aiobotocore-iottwinmaker =
    buildTypesAiobotocorePackage "iottwinmaker" "3.10.0"
      "sha256-q/iySuQS15QNSN/4/l3tKbgh7HvFkgVlmn/SRLNNl/c=";

  types-aiobotocore-iotwireless =
    buildTypesAiobotocorePackage "iotwireless" "3.10.0"
      "sha256-OMSf7WSKPpR09C4wtZ3mAVMJdG8jonkhRLpnr20umwo=";

  types-aiobotocore-ivs =
    buildTypesAiobotocorePackage "ivs" "3.10.0"
      "sha256-8Tobqz2jnecn2lX+d97dFr4ohGHUK2EqxiBerCFgTqo=";

  types-aiobotocore-ivs-realtime =
    buildTypesAiobotocorePackage "ivs-realtime" "3.10.0"
      "sha256-IpkBg6dsr1OtbFVSSotf1fq89SMeByY0D8sZofca89U=";

  types-aiobotocore-ivschat =
    buildTypesAiobotocorePackage "ivschat" "3.10.0"
      "sha256-nUHDTyP66jrLPsA/AWeqri4Jvi0ewUAjc/0nz6Anj4M=";

  types-aiobotocore-kafka =
    buildTypesAiobotocorePackage "kafka" "3.10.0"
      "sha256-VZ89YFFfWII7Skg0yRD+6HSCE6O8dfuLkdWqHI29w50=";

  types-aiobotocore-kafkaconnect =
    buildTypesAiobotocorePackage "kafkaconnect" "3.10.0"
      "sha256-ClkLFWLJW9ORpC/ztJrIUE42hfj397ZzI3xgDy1kCu0=";

  types-aiobotocore-kendra =
    buildTypesAiobotocorePackage "kendra" "3.10.0"
      "sha256-wG5IsZcqQ+mYwt747oYyfHfqU0m+slv4NFqQ+bvhKdI=";

  types-aiobotocore-kendra-ranking =
    buildTypesAiobotocorePackage "kendra-ranking" "3.10.0"
      "sha256-Ic2HFtpGlkjC+PfNcW8BzJN/R6v/7Cp+EWGG/qC4K/o=";

  types-aiobotocore-keyspaces =
    buildTypesAiobotocorePackage "keyspaces" "3.10.0"
      "sha256-TeO9q/cs6s4Nu5oxpq1tFkWwZsYPh1Dbzw0oWL5WdjE=";

  types-aiobotocore-kinesis =
    buildTypesAiobotocorePackage "kinesis" "3.10.0"
      "sha256-XfybFnCE+5m97/2iuOaC4yeOuXYO8ZohfsFl5BbEZzU=";

  types-aiobotocore-kinesis-video-archived-media =
    buildTypesAiobotocorePackage "kinesis-video-archived-media" "3.10.0"
      "sha256-RoPxbCCRtmkphOJAusAQGF+tu1wI90dUI+HMZxKUF1o=";

  types-aiobotocore-kinesis-video-media =
    buildTypesAiobotocorePackage "kinesis-video-media" "3.10.0"
      "sha256-xlu7v3GdTPmGFD7wQR9aRjvKgiBXDnVwUTPMqLzUr/s=";

  types-aiobotocore-kinesis-video-signaling =
    buildTypesAiobotocorePackage "kinesis-video-signaling" "3.10.0"
      "sha256-8oN8HCe3P/hioFkdhtO4yCkCAxovVLxjcfYT26vqA/0=";

  types-aiobotocore-kinesis-video-webrtc-storage =
    buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "3.10.0"
      "sha256-6QK3uB+JfD+k40gE66CTmanNum8fTf9TRviLpjm7TNo=";

  types-aiobotocore-kinesisanalytics =
    buildTypesAiobotocorePackage "kinesisanalytics" "3.10.0"
      "sha256-tGrH48uK9N9U9uU3kLYrHaWrCfEtgRqzLfYvE9zjza4=";

  types-aiobotocore-kinesisanalyticsv2 =
    buildTypesAiobotocorePackage "kinesisanalyticsv2" "3.10.0"
      "sha256-7wEpIBzfKcwt2QggIWu80yf6ndu8gjStQydg5yRhFZA=";

  types-aiobotocore-kinesisvideo =
    buildTypesAiobotocorePackage "kinesisvideo" "3.10.0"
      "sha256-TnHXTdyz1fW0FA0AN2gsIrLRBGCdDE90Loem9mnLdVs=";

  types-aiobotocore-kms =
    buildTypesAiobotocorePackage "kms" "3.10.0"
      "sha256-+Hq/eo5vb749h8W/U0vVcQTTy6oRFUlRuV+3DzXcLW0=";

  types-aiobotocore-lakeformation =
    buildTypesAiobotocorePackage "lakeformation" "3.10.0"
      "sha256-LHHs3kT4ooRivXIL7OD01covuCJFk3WrmkSw6G4RXB0=";

  types-aiobotocore-lambda =
    buildTypesAiobotocorePackage "lambda" "3.10.0"
      "sha256-G5QR4+rdeIqmctxy1ltL550TWrp4E6Im5r0yfGNTdn8=";

  types-aiobotocore-lex-models =
    buildTypesAiobotocorePackage "lex-models" "3.10.0"
      "sha256-aqsa87ITHzQcVV4EPAyK9VdrYm0zrZANsuYz2ZJt3jM=";

  types-aiobotocore-lex-runtime =
    buildTypesAiobotocorePackage "lex-runtime" "3.10.0"
      "sha256-O5rAP5GxRZtfYCLIMwl97wi5iF1hLmMiMoBxK0V0Bww=";

  types-aiobotocore-lexv2-models =
    buildTypesAiobotocorePackage "lexv2-models" "3.10.0"
      "sha256-6htGfh/qeEm5cBqSVAe3Gjf4fHEpMBedoPnpXigx1rI=";

  types-aiobotocore-lexv2-runtime =
    buildTypesAiobotocorePackage "lexv2-runtime" "3.10.0"
      "sha256-o2GTCO5AjZ94LQX59JP0rG2vgWwx1qtrR3Y4qlRcMCI=";

  types-aiobotocore-license-manager =
    buildTypesAiobotocorePackage "license-manager" "3.10.0"
      "sha256-4+C2qVxVGum4Rr8T4QPtOt36gJ7rbrzKndaHkPejHm0=";

  types-aiobotocore-license-manager-linux-subscriptions =
    buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "3.10.0"
      "sha256-1q1EpSiGfM3FrDuAUQcIMPsz0snKksPePeG9XpVbQGg=";

  types-aiobotocore-license-manager-user-subscriptions =
    buildTypesAiobotocorePackage "license-manager-user-subscriptions" "3.10.0"
      "sha256-YI1e9dtSZpTBdkeGvVaKHmOts87zCXH79qjQQlv83Rs=";

  types-aiobotocore-lightsail =
    buildTypesAiobotocorePackage "lightsail" "3.10.0"
      "sha256-eC+N3Wp5TVZ3p4PwEHw2f0m6J0Oq3eM8MVo7m1YgTYA=";

  types-aiobotocore-location =
    buildTypesAiobotocorePackage "location" "3.10.0"
      "sha256-l7Z2SVCh+xijFIb4Gag34llCON5/+/L52jFW1OnOjR0=";

  types-aiobotocore-logs =
    buildTypesAiobotocorePackage "logs" "3.10.0"
      "sha256-bcNrdX2745VZXZ6aDRaVzG+L3mQ6wi7R535dHjQRuzU=";

  types-aiobotocore-lookoutequipment =
    buildTypesAiobotocorePackage "lookoutequipment" "3.10.0"
      "sha256-3z4oYLTWvg7/XUtdKmtbuMLiDZPuW0N4xQRjr3K3hZQ=";

  types-aiobotocore-lookoutmetrics =
    buildTypesAiobotocorePackage "lookoutmetrics" "2.24.2"
      "sha256-u84KeWwmp42KajZ3HnztG1106RN4dGh3jcMfSkJYXNY=";

  types-aiobotocore-lookoutvision =
    buildTypesAiobotocorePackage "lookoutvision" "2.24.2"
      "sha256-HvNqynXLpYFJceCmrlncodqWuoczilMB8QtbCS5pcDM=";

  types-aiobotocore-m2 =
    buildTypesAiobotocorePackage "m2" "3.10.0"
      "sha256-3J7aFZgsj6f64nCJ2V2TpBRDC34il1pD+ifA0CjVGYo=";

  types-aiobotocore-machinelearning =
    buildTypesAiobotocorePackage "machinelearning" "3.10.0"
      "sha256-l8G5J2bCrk/l/rikLDwBfgJsouhxdJYAnX3KztrtoRQ=";

  types-aiobotocore-macie =
    buildTypesAiobotocorePackage "macie" "2.7.0"
      "sha256-hJJtGsK2b56nKX1ZhiarC+ffyjHYWRiC8II4oyDZWWw=";

  types-aiobotocore-macie2 =
    buildTypesAiobotocorePackage "macie2" "3.10.0"
      "sha256-vUtzhWAWOx1/QCJkRfrvarJ6r/BzKwnpPnP/uQf0Osc=";

  types-aiobotocore-managedblockchain =
    buildTypesAiobotocorePackage "managedblockchain" "3.10.0"
      "sha256-HWvgs/LX0nZCGnKmXfxGZxl8KlMY9kpTh9p+aSbrMTo=";

  types-aiobotocore-managedblockchain-query =
    buildTypesAiobotocorePackage "managedblockchain-query" "3.10.0"
      "sha256-I2FlaR7CmqWIAvMzANcYZrCSoIgSW8fLy2KBcFCcKe8=";

  types-aiobotocore-marketplace-catalog =
    buildTypesAiobotocorePackage "marketplace-catalog" "3.10.0"
      "sha256-oiW0RwmBdk/NZJmQVVqp3o1APjgAqaOaPT1E1iqEZGs=";

  types-aiobotocore-marketplace-entitlement =
    buildTypesAiobotocorePackage "marketplace-entitlement" "3.10.0"
      "sha256-VfDHVAS7dVqb2id4Q/iQXh6YbQlv8Fi8T/pX55dHEo8=";

  types-aiobotocore-marketplacecommerceanalytics =
    buildTypesAiobotocorePackage "marketplacecommerceanalytics" "3.10.0"
      "sha256-cAjfvgly7koql60QHYeN72ihw22adUpXqD6cp8QVTj8=";

  types-aiobotocore-mediaconnect =
    buildTypesAiobotocorePackage "mediaconnect" "3.10.0"
      "sha256-ewMvAWk9KXPGfJSzlG6qxBUuhT85O25KSUZ/bjICpwU=";

  types-aiobotocore-mediaconvert =
    buildTypesAiobotocorePackage "mediaconvert" "3.10.0"
      "sha256-G7mShJNidejaG1tveJhQMwUCKFN5bUqbyDnqnEhp0j8=";

  types-aiobotocore-medialive =
    buildTypesAiobotocorePackage "medialive" "3.10.0"
      "sha256-WrhpHwiqJFwDBjE/uEAs6jdO4+MBDNym4IgBmwAj0Ho=";

  types-aiobotocore-mediapackage =
    buildTypesAiobotocorePackage "mediapackage" "3.10.0"
      "sha256-mk0iQsK1YISKfvbbl31Vp4IRobv+UtKVSKcMNMKCkp0=";

  types-aiobotocore-mediapackage-vod =
    buildTypesAiobotocorePackage "mediapackage-vod" "3.10.0"
      "sha256-qJCyjumBhcOPBtuaSyq9mTlpDWqu0znU9HMfMD4skio=";

  types-aiobotocore-mediapackagev2 =
    buildTypesAiobotocorePackage "mediapackagev2" "3.10.0"
      "sha256-37y22y1t+1irImc9Z9Rjf3d4BXIODfDrY4229eosaP0=";

  types-aiobotocore-mediastore =
    buildTypesAiobotocorePackage "mediastore" "3.10.0"
      "sha256-zwHrqhNvgAGs/DKo0wIvdLhfEhZA0sac0kaxw7cT9+k=";

  types-aiobotocore-mediastore-data =
    buildTypesAiobotocorePackage "mediastore-data" "3.10.0"
      "sha256-Qp1gVaFxkULmivR3Uf8QgcBzyOEz57ZORiSBSPAosT4=";

  types-aiobotocore-mediatailor =
    buildTypesAiobotocorePackage "mediatailor" "3.10.0"
      "sha256-R96TSu9NmK0EV3meo4hhLyU0uRK5e8NwBkI+DTeytUA=";

  types-aiobotocore-medical-imaging =
    buildTypesAiobotocorePackage "medical-imaging" "3.10.0"
      "sha256-9AnK6JlCa5K3K/kLvwS1c1w3o0O01vyR7rYbFtdIllQ=";

  types-aiobotocore-memorydb =
    buildTypesAiobotocorePackage "memorydb" "3.10.0"
      "sha256-LyRqUqJF6TjSi+II91gAys+QYoHZWSNE5Agk/seR33U=";

  types-aiobotocore-meteringmarketplace =
    buildTypesAiobotocorePackage "meteringmarketplace" "3.10.0"
      "sha256-T9eQ7Qi/tqlA/KniaZPabsMoRC562X2iX6uhw3W/HTo=";

  types-aiobotocore-mgh =
    buildTypesAiobotocorePackage "mgh" "3.10.0"
      "sha256-xiJfFkUEehf60A6sMTQR6YllZxKNTQZY8pgZ0OwBLC4=";

  types-aiobotocore-mgn =
    buildTypesAiobotocorePackage "mgn" "3.10.0"
      "sha256-v+PgBuRMcNGRGzO0hnSVWOaab+olHowRQkptvy5nTng=";

  types-aiobotocore-migration-hub-refactor-spaces =
    buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "3.10.0"
      "sha256-wpmfEOpe4MHSEB8QCYukOA1cLDTaTe7oa9JIx9TqQW0=";

  types-aiobotocore-migrationhub-config =
    buildTypesAiobotocorePackage "migrationhub-config" "3.10.0"
      "sha256-/6jSJtJdKkuIn9A0jz8L/6v+hCYpbgC7Vp8dnbx0qek=";

  types-aiobotocore-migrationhuborchestrator =
    buildTypesAiobotocorePackage "migrationhuborchestrator" "3.10.0"
      "sha256-revuYuoGmKbvKy1iI6I3gpppJ8o3fbDqWFK6WtyDqi4=";

  types-aiobotocore-migrationhubstrategy =
    buildTypesAiobotocorePackage "migrationhubstrategy" "3.10.0"
      "sha256-7J2dWJ3dk85ooWKMme2iNNZX3nTD6/Beo0qSA8YX2ns=";

  types-aiobotocore-mobile =
    buildTypesAiobotocorePackage "mobile" "2.13.2"
      "sha256-OxB91BCAmYnY72JBWZaBlEkpAxN2Q5aY4i1Pt3eD9hc=";

  types-aiobotocore-mq =
    buildTypesAiobotocorePackage "mq" "3.10.0"
      "sha256-zQAZ8Py3dOdxv80iC3pAQL/C1BDkGK77ixKHoPyyKMA=";

  types-aiobotocore-mturk =
    buildTypesAiobotocorePackage "mturk" "3.10.0"
      "sha256-NFGfY0OKRCqHpmaH0Gqww41isWXDq3O5GcpkuF23Br4=";

  types-aiobotocore-mwaa =
    buildTypesAiobotocorePackage "mwaa" "3.10.0"
      "sha256-jD60ggujXOthv7LZFPW+ukxOTongjXq8aaOJaccVFWc=";

  types-aiobotocore-neptune =
    buildTypesAiobotocorePackage "neptune" "3.10.0"
      "sha256-rhNbMsIW5hz97lEfkOCt9x0zBZzfqDacp0Nm2jxRaKo=";

  types-aiobotocore-network-firewall =
    buildTypesAiobotocorePackage "network-firewall" "3.10.0"
      "sha256-uea0WRB6DLMVtLbHGjfShvY+uhczyj1NKM/UZbWiYtg=";

  types-aiobotocore-networkmanager =
    buildTypesAiobotocorePackage "networkmanager" "3.10.0"
      "sha256-jzF+0SfsJeDoshHQqZYN/DB9LMyyu/SC2VcXfdZn6M8=";

  types-aiobotocore-networkmonitor =
    buildTypesAiobotocorePackage "networkmonitor" "3.10.0"
      "sha256-odWf8vwQ8X4gvg+5YWAeBb0XGhCTzBlhxlK4pKd8bks=";

  types-aiobotocore-nimble =
    buildTypesAiobotocorePackage "nimble" "2.15.2"
      "sha256-PChX5Jbgr0d1YaTZU9AbX3cM7NrhkyunK6/X3l+I8Q0=";

  types-aiobotocore-oam =
    buildTypesAiobotocorePackage "oam" "3.10.0"
      "sha256-ZtjM9B0VcZSx41t97B5+6FRL+dir5nwVJJYTxbIwZh8=";

  types-aiobotocore-omics =
    buildTypesAiobotocorePackage "omics" "3.10.0"
      "sha256-5711LAEeD4rJu6+Q5GG5YkULVebz3UiQ4ZiezePriKk=";

  types-aiobotocore-opensearch =
    buildTypesAiobotocorePackage "opensearch" "3.10.0"
      "sha256-VXrqnOOiiVscHPDXVLcedKR7qM7cgbRYwXfV+riPOrA=";

  types-aiobotocore-opensearchserverless =
    buildTypesAiobotocorePackage "opensearchserverless" "3.10.0"
      "sha256-5P/gsFULA1KrhF1Iy9Gu8D7NW8JmSijVcTeThfqIon8=";

  types-aiobotocore-opsworks =
    buildTypesAiobotocorePackage "opsworks" "2.24.2"
      "sha256-ScEMFhogJRX6ykymK3rqYniGVcyJEsECKvnnbT3xv1A=";

  types-aiobotocore-opsworkscm =
    buildTypesAiobotocorePackage "opsworkscm" "2.24.2"
      "sha256-i+qoE5XXWpZ7dQeDagkD2MhnBjwbKTJYyZxATDh8h9M=";

  types-aiobotocore-organizations =
    buildTypesAiobotocorePackage "organizations" "3.10.0"
      "sha256-LuCAqLRLnGNOGK8uTwTSZrJHBGlbbRwwICs4+kSzgqA=";

  types-aiobotocore-osis =
    buildTypesAiobotocorePackage "osis" "3.10.0"
      "sha256-se0Y5gGnJWo1BzFdExlnjOx3u7e24zDUBR94DDRBWO8=";

  types-aiobotocore-outposts =
    buildTypesAiobotocorePackage "outposts" "3.10.0"
      "sha256-COYvwxbJzPWMyRptFZLRQI5DPXZqVGWcAw7beXEAarQ=";

  types-aiobotocore-panorama =
    buildTypesAiobotocorePackage "panorama" "3.7.0"
      "sha256-yn1EAIvzNfFR1a3r8y9Ri5nOdprgEAYBuXw2Wt1hYIs=";

  types-aiobotocore-payment-cryptography =
    buildTypesAiobotocorePackage "payment-cryptography" "3.10.0"
      "sha256-0dDAJG2/f7EHMhGE7yxflZ6OGtDt6En6nuYCElVXOlQ=";

  types-aiobotocore-payment-cryptography-data =
    buildTypesAiobotocorePackage "payment-cryptography-data" "3.10.0"
      "sha256-kevNET1QYMSfoBlkKXPzmjDKNMuDtV3SY25F8VeOkUY=";

  types-aiobotocore-personalize =
    buildTypesAiobotocorePackage "personalize" "3.10.0"
      "sha256-4EkiTF3k/1OjwqvYvRDvekqcE2au6t96jhqsEFYiAfQ=";

  types-aiobotocore-personalize-events =
    buildTypesAiobotocorePackage "personalize-events" "3.10.0"
      "sha256-o2mYusWiN4W7FpQqoVgN8ZhuI0cvGSN4byWHtYcyT1Y=";

  types-aiobotocore-personalize-runtime =
    buildTypesAiobotocorePackage "personalize-runtime" "3.10.0"
      "sha256-umOULl2aAzjSTY2XlNUyev4AuB5ZQ9lI4r0EMAc4Lx0=";

  types-aiobotocore-pi =
    buildTypesAiobotocorePackage "pi" "3.10.0"
      "sha256-adz4GORzK+VJmXYqSzIpfdFGlyxzOK8LC5nW+H4BRvI=";

  types-aiobotocore-pinpoint =
    buildTypesAiobotocorePackage "pinpoint" "3.10.0"
      "sha256-r0dRgvjsNVxgDxg4H1ra47CqtMjbkgk8ju2d3gkp3nY=";

  types-aiobotocore-pinpoint-email =
    buildTypesAiobotocorePackage "pinpoint-email" "3.10.0"
      "sha256-Rhk4fLFqYgF98PkgNW5TGceSQUPpZthDXqUaTorLXXc=";

  types-aiobotocore-pinpoint-sms-voice =
    buildTypesAiobotocorePackage "pinpoint-sms-voice" "3.10.0"
      "sha256-anCD/h5BRkBwlfEg7D9EXbX+rKNt47x1AWULZBKNFlg=";

  types-aiobotocore-pinpoint-sms-voice-v2 =
    buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "3.10.0"
      "sha256-vSWzlEvwR6LknoVb3EpESAJsBF8QyZt32ufxUoa/Jqc=";

  types-aiobotocore-pipes =
    buildTypesAiobotocorePackage "pipes" "3.10.0"
      "sha256-eXF1exOvdLrUUXhxjndsEPOoc4w/AXdC1EQHHyfUgBk=";

  types-aiobotocore-polly =
    buildTypesAiobotocorePackage "polly" "3.10.0"
      "sha256-+UWIz9Eon8+6JBLrVRx0qYb7j2kpFjTmSB7nqvK1/EM=";

  types-aiobotocore-pricing =
    buildTypesAiobotocorePackage "pricing" "3.10.0"
      "sha256-uUnj6j6v8z8PzrgvBeHCfAccdMQCCvd38A/Y82SFY4E=";

  types-aiobotocore-privatenetworks =
    buildTypesAiobotocorePackage "privatenetworks" "2.22.0"
      "sha256-yaYvgVKcr3l2eq0dMzmQEZHxgblTLlVF9cZRnObiB7M=";

  types-aiobotocore-proton =
    buildTypesAiobotocorePackage "proton" "3.10.0"
      "sha256-xnH2SCW/bZ3R9Nst+rx7od4wuuj3V2nk62U8XVOGtlo=";

  types-aiobotocore-qapps =
    buildTypesAiobotocorePackage "qapps" "3.10.0"
      "sha256-oeV7Jq18OvlfLWQXqi9MpBO7qwGhz/pCo2qQxBhb99E=";

  types-aiobotocore-qbusiness =
    buildTypesAiobotocorePackage "qbusiness" "3.10.0"
      "sha256-tuHSSrO7fd8qSsI+wN8qrQGeGW6h+zJ4CmpZpN2Uu1s=";

  types-aiobotocore-qconnect =
    buildTypesAiobotocorePackage "qconnect" "3.10.0"
      "sha256-8b3D5b5Si+Ytr2BuJrMh9P/nQLHm3gOhIVNDRVMXRVQ=";

  types-aiobotocore-qldb =
    buildTypesAiobotocorePackage "qldb" "2.24.2"
      "sha256-qrSbXgc4DBb2kNg0ydb1vT9EmRqQWNIfuNOVsK8BPY0=";

  types-aiobotocore-qldb-session =
    buildTypesAiobotocorePackage "qldb-session" "2.24.2"
      "sha256-Lk9RLigcg4F/AsgKneBUoyPyeUh46ra+BLCw94b74eU=";

  types-aiobotocore-quicksight =
    buildTypesAiobotocorePackage "quicksight" "3.10.0"
      "sha256-+NmR9P2BnPi2WOSOFxKWHQl5SSFJngZtUJKDmf1LXqs=";

  types-aiobotocore-ram =
    buildTypesAiobotocorePackage "ram" "3.10.0"
      "sha256-8tAiVlO649qK+gYzVLttW5iA1cBPkHM8s2lkywPOpFo=";

  types-aiobotocore-rbin =
    buildTypesAiobotocorePackage "rbin" "3.10.0"
      "sha256-VG5s6qQAyFudJc0W0wAaCeDCFaKkLFN8F9Y8j2tKpPc=";

  types-aiobotocore-rds =
    buildTypesAiobotocorePackage "rds" "3.10.0"
      "sha256-1442REKEhgca2C2KXakphze/luu3kYI3K0B5TXnQfM8=";

  types-aiobotocore-rds-data =
    buildTypesAiobotocorePackage "rds-data" "3.10.0"
      "sha256-gPJIDiG8/d3gYP9EWkoHN/lhw56H0pGCiXteFiBft30=";

  types-aiobotocore-redshift =
    buildTypesAiobotocorePackage "redshift" "3.10.0"
      "sha256-yT78YAzu/NyroFnLN/1OQwucUxhDwmb/D+fgiE0QXP4=";

  types-aiobotocore-redshift-data =
    buildTypesAiobotocorePackage "redshift-data" "3.10.0"
      "sha256-L9rwSjVqllup39NG5hRAZ9WdaA6u8JOYuJE9auJjXs4=";

  types-aiobotocore-redshift-serverless =
    buildTypesAiobotocorePackage "redshift-serverless" "3.10.0"
      "sha256-YuU/pjETxUOvyjwjlFM/0zm/vbZ2YgncrA7ZDj5jK68=";

  types-aiobotocore-rekognition =
    buildTypesAiobotocorePackage "rekognition" "3.10.0"
      "sha256-xC5iLGFPlLzvVkBPL2oYs+0ySzq+nvLPeBfOUwgbXuw=";

  types-aiobotocore-resiliencehub =
    buildTypesAiobotocorePackage "resiliencehub" "3.10.0"
      "sha256-QwEGi85yZ+vzsqvNsF5KSeP9XpbhV7XEuIuVkmoIEhg=";

  types-aiobotocore-resource-explorer-2 =
    buildTypesAiobotocorePackage "resource-explorer-2" "3.10.0"
      "sha256-XD0Kz7ohb8M/eh1OBorD+YWFeDhm/CvkRdfDuz698ag=";

  types-aiobotocore-resource-groups =
    buildTypesAiobotocorePackage "resource-groups" "3.10.0"
      "sha256-PZPK2bO1faUnXHnVw9a5xcfdzYeWHoAnPUw1RUHQMrg=";

  types-aiobotocore-resourcegroupstaggingapi =
    buildTypesAiobotocorePackage "resourcegroupstaggingapi" "3.10.0"
      "sha256-vswRUro/VSkyj7WoffMVQOTHMtJFm39iel5Wbuusq0U=";

  types-aiobotocore-robomaker =
    buildTypesAiobotocorePackage "robomaker" "2.24.2"
      "sha256-EczunxMisSO9t2iYzXuzTeFiNalu2EyDRIOE7TW5fOg=";

  types-aiobotocore-rolesanywhere =
    buildTypesAiobotocorePackage "rolesanywhere" "3.10.0"
      "sha256-I3HfrGotARuWAt5ND5XBV4LBw6ODvwiZfNw/SBGimg0=";

  types-aiobotocore-route53 =
    buildTypesAiobotocorePackage "route53" "3.10.0"
      "sha256-3FRm5ao5bTtn+YkTPf3fmtXnSY99An9G9ODb8pVq038=";

  types-aiobotocore-route53-recovery-cluster =
    buildTypesAiobotocorePackage "route53-recovery-cluster" "3.10.0"
      "sha256-df8kvJNDC1jZlu7naY7fti2qukEHu34PhQBz4XmyDMU=";

  types-aiobotocore-route53-recovery-control-config =
    buildTypesAiobotocorePackage "route53-recovery-control-config" "3.10.0"
      "sha256-+JlfY9xDbpHzp05um+FujFKTm/nbwL0zQVfJVQFhP/c=";

  types-aiobotocore-route53-recovery-readiness =
    buildTypesAiobotocorePackage "route53-recovery-readiness" "3.10.0"
      "sha256-+8+sb1DHRjqTs9kjrX1o397bFmK/yEchdx+mjBtoeaM=";

  types-aiobotocore-route53domains =
    buildTypesAiobotocorePackage "route53domains" "3.10.0"
      "sha256-7WUEuvJVnMRT0vWoaoQKQY0lqbmyI75izh7WdElPyg8=";

  types-aiobotocore-route53resolver =
    buildTypesAiobotocorePackage "route53resolver" "3.10.0"
      "sha256-5JvFY7+Pt0uv1cJZl3Uu1UVebXxrf++Xf3wQcdbLdmE=";

  types-aiobotocore-rum =
    buildTypesAiobotocorePackage "rum" "3.10.0"
      "sha256-mh3mRFRv5DzhFAv+SaIm4VA5L31Llm8kz/j3gfeDAKE=";

  types-aiobotocore-s3 =
    buildTypesAiobotocorePackage "s3" "3.10.0"
      "sha256-W947HMEfFLzfmRt13BW92ISnpF+A5Xy6ck3goZZCTKo=";

  types-aiobotocore-s3control =
    buildTypesAiobotocorePackage "s3control" "3.10.0"
      "sha256-BByWwT2sjjeK9yMrgYUCaaqyrImmzhjwlx/SDsof4P0=";

  types-aiobotocore-s3outposts =
    buildTypesAiobotocorePackage "s3outposts" "3.10.0"
      "sha256-a2d+thXiUTwQZqo5TJoaxCYYbPA6YBxdfDEviCvnKOM=";

  types-aiobotocore-sagemaker =
    buildTypesAiobotocorePackage "sagemaker" "3.10.0"
      "sha256-pdUPbkxeE5JBdAkgNFiIcuXIvBBCRbihTNSuSzLaZSU=";

  types-aiobotocore-sagemaker-a2i-runtime =
    buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "3.10.0"
      "sha256-OdYszz01IV9hcq7iZmKwvVz6nrzpMscADJ3gfu/a7E0=";

  types-aiobotocore-sagemaker-edge =
    buildTypesAiobotocorePackage "sagemaker-edge" "3.10.0"
      "sha256-enDcUdRKYCuaCrxUzv2Ys+K1ZnGtxMSH+jGD4EJKYoo=";

  types-aiobotocore-sagemaker-featurestore-runtime =
    buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "3.10.0"
      "sha256-hIGeS0VDUDRm2QR0kkfwyKjiItf2XRFq8AHy+VcamBs=";

  types-aiobotocore-sagemaker-geospatial =
    buildTypesAiobotocorePackage "sagemaker-geospatial" "3.10.0"
      "sha256-OUmiHxd2sghDkgfg26yd0vG2iDi2cQNxjne5kubs6jk=";

  types-aiobotocore-sagemaker-metrics =
    buildTypesAiobotocorePackage "sagemaker-metrics" "3.10.0"
      "sha256-dNP3Ct+qFTEslVb3dWUO9j+xjUXK2DBKZ2Wd8eZYPq8=";

  types-aiobotocore-sagemaker-runtime =
    buildTypesAiobotocorePackage "sagemaker-runtime" "3.10.0"
      "sha256-108Ok3NFcX17Z9h07X5tlu7/SiXy4nRf/7hIyur8OH4=";

  types-aiobotocore-savingsplans =
    buildTypesAiobotocorePackage "savingsplans" "3.10.0"
      "sha256-O0H2rIOf61eNxK5jDhg0KlUlv9x4L3l9zNO5+cNzOvk=";

  types-aiobotocore-scheduler =
    buildTypesAiobotocorePackage "scheduler" "3.10.0"
      "sha256-Ymb8NKQHcw6EKQzv/2io0Hjxqt07xfZRHoMvFovtavQ=";

  types-aiobotocore-schemas =
    buildTypesAiobotocorePackage "schemas" "3.10.0"
      "sha256-7+tF1Tx1yi7uJmeTF3M/XYxFyF+h4KhyXqN1dJUP4RU=";

  types-aiobotocore-sdb =
    buildTypesAiobotocorePackage "sdb" "3.10.0"
      "sha256-0FMAKlslx7ILbr4tomZvt15i7KbIgcATJ/BtJ1YB7Cg=";

  types-aiobotocore-secretsmanager =
    buildTypesAiobotocorePackage "secretsmanager" "3.10.0"
      "sha256-upooaq1+PN7c4Ri7t32abqAmWIs3f2w/2TuuBfVon0g=";

  types-aiobotocore-securityhub =
    buildTypesAiobotocorePackage "securityhub" "3.10.0"
      "sha256-OX5xoSvIXxKGbo9VyOs+GZCFTodzICe7SpmO51p4Mmw=";

  types-aiobotocore-securitylake =
    buildTypesAiobotocorePackage "securitylake" "3.10.0"
      "sha256-n5/2LRuM2DfSZbyAy9xT65yTe0bQaDyT83DxfFiRmxU=";

  types-aiobotocore-serverlessrepo =
    buildTypesAiobotocorePackage "serverlessrepo" "3.10.0"
      "sha256-nlXqpwVHCPSZTIzz8y4jIDy4dvAiKHrcWYxyTr0G/Uk=";

  types-aiobotocore-service-quotas =
    buildTypesAiobotocorePackage "service-quotas" "3.10.0"
      "sha256-PJ6mKVfuIm79HcP/4fQZgASltjrLLZtRaqtL1SKhCE4=";

  types-aiobotocore-servicecatalog =
    buildTypesAiobotocorePackage "servicecatalog" "3.10.0"
      "sha256-1w6pQP8bfYJn7+3dSH84QRkP6iWS/sykkWbT7Fid2Rw=";

  types-aiobotocore-servicecatalog-appregistry =
    buildTypesAiobotocorePackage "servicecatalog-appregistry" "3.10.0"
      "sha256-dqRH+amRcLtnMKo7kZTn19P5UEdy+psaxEWO0VpzgQc=";

  types-aiobotocore-servicediscovery =
    buildTypesAiobotocorePackage "servicediscovery" "3.10.0"
      "sha256-PGkJ/mY9kiu8AN0014PSLH199AVIkSgZhkZq/r60vCs=";

  types-aiobotocore-ses =
    buildTypesAiobotocorePackage "ses" "3.10.0"
      "sha256-8nu46+KfCsXaMzPoxuEYMUAAdcBuPll7NawN01ihyGs=";

  types-aiobotocore-sesv2 =
    buildTypesAiobotocorePackage "sesv2" "3.10.0"
      "sha256-r/ukCl3kAzJXKVKyriarvEZi5iT+WBGPVsJjgw6gvi8=";

  types-aiobotocore-shield =
    buildTypesAiobotocorePackage "shield" "3.10.0"
      "sha256-Jd3zUlArNJwMcwsxXM4Be0jA/R6Hn9cUdOp5EW8EiSI=";

  types-aiobotocore-signer =
    buildTypesAiobotocorePackage "signer" "3.10.0"
      "sha256-hsW1/Wa3mC5WlB3Y3zQYdRrGuG4yeZyXF5rYeyq8cDc=";

  types-aiobotocore-simspaceweaver =
    buildTypesAiobotocorePackage "simspaceweaver" "3.7.0"
      "sha256-tZQL781zQI+vVvO0S3cHzw5RGAHKXeNeJW7E8tzCHA4=";

  types-aiobotocore-sms =
    buildTypesAiobotocorePackage "sms" "2.24.2"
      "sha256-aZuGmKtxe3ERjMUZ5jNiZUaVUqDaCHKQQ6wMTsGkcVs=";

  types-aiobotocore-sms-voice =
    buildTypesAiobotocorePackage "sms-voice" "2.22.0"
      "sha256-nlg8QppdMa4MMLUQZXcxnypzv5II9PqEtuVc09UmjKU=";

  types-aiobotocore-snow-device-management =
    buildTypesAiobotocorePackage "snow-device-management" "3.10.0"
      "sha256-bjiT6g7CYKLXWXaFqO0IbVCMFmV8VknAxtWFn6/hv4k=";

  types-aiobotocore-snowball =
    buildTypesAiobotocorePackage "snowball" "3.10.0"
      "sha256-H5Efcs7DS2rViHN2fXqeay3d0gaa5Y+ADLrFKw694Go=";

  types-aiobotocore-sns =
    buildTypesAiobotocorePackage "sns" "3.10.0"
      "sha256-7+U5kHVuJB2c15LPAgTFkScYZSGNuabKVnxPagVwPPI=";

  types-aiobotocore-sqs =
    buildTypesAiobotocorePackage "sqs" "3.10.0"
      "sha256-U8a/wj1Ivy21/j53DPEuyNZwOfc39IoA2fJT8JAqm5Q=";

  types-aiobotocore-ssm =
    buildTypesAiobotocorePackage "ssm" "3.10.0"
      "sha256-+puzDz5TDChY8GXONenAPjZl6q9QI7HGX88WAemz0YA=";

  types-aiobotocore-ssm-contacts =
    buildTypesAiobotocorePackage "ssm-contacts" "3.10.0"
      "sha256-jw1lOuXWDuNCqy9qpCOhlNQzjjAVqhMeJU0QSGQ5T+k=";

  types-aiobotocore-ssm-incidents =
    buildTypesAiobotocorePackage "ssm-incidents" "3.10.0"
      "sha256-mENGaNswGW/7WlBcUgLkfnfQIrkAGEoqy0gmzSshRus=";

  types-aiobotocore-ssm-sap =
    buildTypesAiobotocorePackage "ssm-sap" "3.10.0"
      "sha256-d7XLl/Az3N/3I/pE+iB9fs2EVMUSyvOv/UuwAQTDVps=";

  types-aiobotocore-sso =
    buildTypesAiobotocorePackage "sso" "3.10.0"
      "sha256-tKjnpdqGcequ5vxNNJLR6prY6AMg1o8+57Uta+M8pMc=";

  types-aiobotocore-sso-admin =
    buildTypesAiobotocorePackage "sso-admin" "3.10.0"
      "sha256-YlDXuyPgyuSmoNcQr4wmGJ9R5mon8Ka94Bn6ScpD0Po=";

  types-aiobotocore-sso-oidc =
    buildTypesAiobotocorePackage "sso-oidc" "3.10.0"
      "sha256-75P+9qy2Lc7eOimFK8R+5xxJ29Zi2jfG43jZSoYnoDM=";

  types-aiobotocore-stepfunctions =
    buildTypesAiobotocorePackage "stepfunctions" "3.10.0"
      "sha256-CyarWhGD4+uODjGPKRemeCQFB54aiRzMnYbQeNyhpIY=";

  types-aiobotocore-storagegateway =
    buildTypesAiobotocorePackage "storagegateway" "3.10.0"
      "sha256-jKQPtGeSkfKKPcgHrl1+7pubVhgYiYjv45Kq7ruiMnk=";

  types-aiobotocore-sts =
    buildTypesAiobotocorePackage "sts" "3.10.0"
      "sha256-YJ191kZVnHj2VI9MxAroIu/gN41AsgfHCYXFvyMAkq4=";

  types-aiobotocore-support =
    buildTypesAiobotocorePackage "support" "3.10.0"
      "sha256-6kpM8F2YDYBBQ3eqGdgwjsbIUQil0LhM+8DEf7hk+9M=";

  types-aiobotocore-support-app =
    buildTypesAiobotocorePackage "support-app" "3.10.0"
      "sha256-cmjJ7ku331hGGeGZoxSEifp3D1rUlNkdLYRv9WtLD1s=";

  types-aiobotocore-swf =
    buildTypesAiobotocorePackage "swf" "3.10.0"
      "sha256-0F/rY13DyrtPkA+kxRxW0GOHAtBSU9Z9l1UI1r/meCw=";

  types-aiobotocore-synthetics =
    buildTypesAiobotocorePackage "synthetics" "3.10.0"
      "sha256-P0Nzhuh3GrI6k5jAx+Z9rx6V1lyZs9XRQI2VDeqKmD8=";

  types-aiobotocore-textract =
    buildTypesAiobotocorePackage "textract" "3.10.0"
      "sha256-4QzHUgOJb99IC7KM/5+wpxzHxRNbgPkN4BYZYzE0bDU=";

  types-aiobotocore-timestream-query =
    buildTypesAiobotocorePackage "timestream-query" "3.10.0"
      "sha256-CydNaGuDD3nvY06wWLjYEe3tn92YlDyXgF7pgvwgAvE=";

  types-aiobotocore-timestream-write =
    buildTypesAiobotocorePackage "timestream-write" "3.10.0"
      "sha256-B+CisyABZhMNJc1Iee6k5I8wLaHPeB5ycT/lc9U/a7M=";

  types-aiobotocore-tnb =
    buildTypesAiobotocorePackage "tnb" "3.9.2"
      "sha256-H1l4DMqga0HexIhQ1D7LvLx/cbKRxKjiNU1KHMB0NZg=";

  types-aiobotocore-transcribe =
    buildTypesAiobotocorePackage "transcribe" "3.10.0"
      "sha256-pHL1KjlVxJ0k5m+9KZzQjX16qMIQKJAcFDxLqQ7Am24=";

  types-aiobotocore-transfer =
    buildTypesAiobotocorePackage "transfer" "3.10.0"
      "sha256-CUSgPaFUOl503iNKVssTVKBNCGuqONpdhPY5Bl2kv+0=";

  types-aiobotocore-translate =
    buildTypesAiobotocorePackage "translate" "3.10.0"
      "sha256-JheCX52WcO+oNf/hitC9kYufh7OfGr4HN8cCA+4oIUQ=";

  types-aiobotocore-verifiedpermissions =
    buildTypesAiobotocorePackage "verifiedpermissions" "3.10.0"
      "sha256-Pi9h16t/UhHW01sgXvjd2rinU42pKYMjdtsUeRwEtNE=";

  types-aiobotocore-voice-id =
    buildTypesAiobotocorePackage "voice-id" "3.10.0"
      "sha256-61EPg4YUcfiYwToZFKgBBJ51Ofi/HT5DmxzTcyVlDtQ=";

  types-aiobotocore-vpc-lattice =
    buildTypesAiobotocorePackage "vpc-lattice" "3.10.0"
      "sha256-79BVPJfEze3CbbVV4CDttC9HSqFB5DQRyVDk089U9Bo=";

  types-aiobotocore-waf =
    buildTypesAiobotocorePackage "waf" "3.10.0"
      "sha256-PDGyRgRJPdfekpTiL2WPQLaSuPd+z1qDqUaH9WfVUXY=";

  types-aiobotocore-waf-regional =
    buildTypesAiobotocorePackage "waf-regional" "3.10.0"
      "sha256-FTiU5vIfwaAYP66RVuPMUt+HtfrhAp2YHJaDhZIpcWY=";

  types-aiobotocore-wafv2 =
    buildTypesAiobotocorePackage "wafv2" "3.10.0"
      "sha256-X4w+vHvCjwFf7uZYEO8Nc2Sb874AjHfGREV0WmzYzxo=";

  types-aiobotocore-wellarchitected =
    buildTypesAiobotocorePackage "wellarchitected" "3.10.0"
      "sha256-IgNseYBrKgQkJJVIzt+MtLqDmRjJnBRfrbKd9Ib4hbw=";

  types-aiobotocore-wisdom =
    buildTypesAiobotocorePackage "wisdom" "3.10.0"
      "sha256-x0vd3hJj95wPORCWsjdzg8eV3qgiDm5Z15FT/3BgbLw=";

  types-aiobotocore-workdocs =
    buildTypesAiobotocorePackage "workdocs" "3.10.0"
      "sha256-ndDkuJ+RLixDUPOnSWMxBrrEbNvU/XczYs5BNRNq938=";

  types-aiobotocore-worklink =
    buildTypesAiobotocorePackage "worklink" "2.15.1"
      "sha256-VvuxiybvGaehPqyVUYGO1bbVSQ0OYgk6LbzgoKLHF2c=";

  types-aiobotocore-workmail =
    buildTypesAiobotocorePackage "workmail" "3.10.0"
      "sha256-D4vLMenDwX1L0MhWErmYAotalNH+SmX6za7p+1Lu9g8=";

  types-aiobotocore-workmailmessageflow =
    buildTypesAiobotocorePackage "workmailmessageflow" "3.10.0"
      "sha256-7A8ANydgGaxlJ+LU4QiLqWjHyC00FRrF6EOIG2aEghc=";

  types-aiobotocore-workspaces =
    buildTypesAiobotocorePackage "workspaces" "3.10.0"
      "sha256-GeAbjxRqhPzdxKv8EYdVvtmlRAqTbKCwFfr0FDN/ATg=";

  types-aiobotocore-workspaces-web =
    buildTypesAiobotocorePackage "workspaces-web" "3.10.0"
      "sha256-NHuHls6lQUuXGIx0ODg86vbn4u1wZY02I3eCNzzR4Yk=";

  types-aiobotocore-xray =
    buildTypesAiobotocorePackage "xray" "3.10.0"
      "sha256-KFOocfBDiXMGjqC5TdIc2xXd/8GPd8PONECfZCfLAhk=";
}
