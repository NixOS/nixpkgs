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
      ]
      ++ lib.optionals (pythonOlder "3.12") [ typing-extensions ];

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
{
  types-aiobotocore-accessanalyzer =
    buildTypesAiobotocorePackage "accessanalyzer" "2.25.2"
      "sha256-IEVDklcUHZFgtP4QlI9bGOJ6dx+rJoBF3XRoFH5DZV0=";

  types-aiobotocore-account =
    buildTypesAiobotocorePackage "account" "2.25.2"
      "sha256-lBkm+8rmTzl9q9g7Fzgp9sdAosdDckamnxeUWZxir+E=";

  types-aiobotocore-acm =
    buildTypesAiobotocorePackage "acm" "2.25.2"
      "sha256-lNlDVxNTMz9vGU94nIjkEji35679Bm0yv4CUGYGpADE=";

  types-aiobotocore-acm-pca =
    buildTypesAiobotocorePackage "acm-pca" "2.25.2"
      "sha256-N+knWZbvPGheg1JAp1xuUTpIQex4q4sntsJqTA73Y+Y=";

  types-aiobotocore-alexaforbusiness =
    buildTypesAiobotocorePackage "alexaforbusiness" "2.13.0"
      "sha256-+w/InoQR2aZ5prieGhgEEp7auBiSSghG5zIIHY5Kyao=";

  types-aiobotocore-amp =
    buildTypesAiobotocorePackage "amp" "2.25.2"
      "sha256-My6WiULfsM3fZTlvcB1nS1t+QbXWngPKDlsDym+GbB0=";

  types-aiobotocore-amplify =
    buildTypesAiobotocorePackage "amplify" "2.25.2"
      "sha256-t+8zj70sq2Z28CLqrZig6iGYsVpCDK6lQP8VBVbvKlM=";

  types-aiobotocore-amplifybackend =
    buildTypesAiobotocorePackage "amplifybackend" "2.25.2"
      "sha256-lGQKvzPp/4/imk+cimBv6JGzMb7pOHW1M8sqhlLDWtY=";

  types-aiobotocore-amplifyuibuilder =
    buildTypesAiobotocorePackage "amplifyuibuilder" "2.25.2"
      "sha256-Rif++XP7pJB8qF8RZuZFAWDb25d2yPvvW+LGuVzEDBI=";

  types-aiobotocore-apigateway =
    buildTypesAiobotocorePackage "apigateway" "2.25.2"
      "sha256-nuWtmXwABeagUB+ZwBQdChlsYcr8o8LLWwR/moCS5Ug=";

  types-aiobotocore-apigatewaymanagementapi =
    buildTypesAiobotocorePackage "apigatewaymanagementapi" "2.25.2"
      "sha256-zw8Hvozkw5CVVNLknURQlCxWPj/54PUtvRRJsZPUpkI=";

  types-aiobotocore-apigatewayv2 =
    buildTypesAiobotocorePackage "apigatewayv2" "2.25.2"
      "sha256-r/jzrpCxyhMRLL027ReAn4VoLi38QcDglhf5tDHXDoY=";

  types-aiobotocore-appconfig =
    buildTypesAiobotocorePackage "appconfig" "2.25.2"
      "sha256-4cNOGYpc+yIEWdJyNUg/H9bQ1QYIVlhhzJO24m+bkNg=";

  types-aiobotocore-appconfigdata =
    buildTypesAiobotocorePackage "appconfigdata" "2.25.2"
      "sha256-5tG2fa1jkG5GAY86hfN7qiIlj7eyB9UMZfFPz/hSR88=";

  types-aiobotocore-appfabric =
    buildTypesAiobotocorePackage "appfabric" "2.25.2"
      "sha256-RnQmDns+PGXWlacfQvRGbE62Bgzn7Ywu8y5zrBns9x8=";

  types-aiobotocore-appflow =
    buildTypesAiobotocorePackage "appflow" "2.25.2"
      "sha256-drfnki+v2Q53QvmV0b1FbZLArS7t8poPwwVGxfV9w/E=";

  types-aiobotocore-appintegrations =
    buildTypesAiobotocorePackage "appintegrations" "2.25.2"
      "sha256-9G/D6fljKmCxHpcek2Igg7r9c5vfY4Z6YAUn7PSKLYY=";

  types-aiobotocore-application-autoscaling =
    buildTypesAiobotocorePackage "application-autoscaling" "2.25.2"
      "sha256-dZ6lSgGt/boCIRzw8SF4V1UmTYMGFmdtZPnfECRfUaU=";

  types-aiobotocore-application-insights =
    buildTypesAiobotocorePackage "application-insights" "2.25.2"
      "sha256-++JxtGTETwjLcZLxPlvqdd8eJYIQwvu4ktz8WyFRla0=";

  types-aiobotocore-applicationcostprofiler =
    buildTypesAiobotocorePackage "applicationcostprofiler" "2.25.2"
      "sha256-hifchHQHQWmuYR1eMlTawb+v7YcqFT9WUuRzWZt0Miw=";

  types-aiobotocore-appmesh =
    buildTypesAiobotocorePackage "appmesh" "2.25.2"
      "sha256-mIr99MgKQHHLUf21F4bWWxsja5v7mSI13X97Q3fGjBo=";

  types-aiobotocore-apprunner =
    buildTypesAiobotocorePackage "apprunner" "2.25.2"
      "sha256-VHwS2bYiyXWQX97rxH4OJifliMXtyve6pUKUZRjMKes=";

  types-aiobotocore-appstream =
    buildTypesAiobotocorePackage "appstream" "2.25.2"
      "sha256-YbYiz/Eu2LONb+j0r1fnjmL3Ur/CuZRFB5eYc29+XR0=";

  types-aiobotocore-appsync =
    buildTypesAiobotocorePackage "appsync" "2.25.2"
      "sha256-9YzlcCwMEN4/6WN1FSD6xgX/YErA/KY+XIsI+B8cIfA=";

  types-aiobotocore-arc-zonal-shift =
    buildTypesAiobotocorePackage "arc-zonal-shift" "2.25.2"
      "sha256-hghumRzqZq012I58LscweLLIlF8pumI9x9UApuAHlrY=";

  types-aiobotocore-athena =
    buildTypesAiobotocorePackage "athena" "2.25.2"
      "sha256-xcF4E97R7nSyk1NWfjeDEjEOeC0RFgwl+mF3pVjnWMc=";

  types-aiobotocore-auditmanager =
    buildTypesAiobotocorePackage "auditmanager" "2.25.2"
      "sha256-pQc++c5VLsXfqPC/oSzLawFdFiyMerwySFOOTsEEHt4=";

  types-aiobotocore-autoscaling =
    buildTypesAiobotocorePackage "autoscaling" "2.25.2"
      "sha256-y8+kALV1vSdG6LNIFtix05R4WSjkW5s1ksP3TgC3Yqc=";

  types-aiobotocore-autoscaling-plans =
    buildTypesAiobotocorePackage "autoscaling-plans" "2.25.2"
      "sha256-OCek+Co+1p0DcaiYK5tF+eYiUxFN/YEcQr5dgMY43oo=";

  types-aiobotocore-backup =
    buildTypesAiobotocorePackage "backup" "2.25.2"
      "sha256-gIItTVD+2uF1icezCy95+O8X/GUqN3HE892vKc14btw=";

  types-aiobotocore-backup-gateway =
    buildTypesAiobotocorePackage "backup-gateway" "2.25.2"
      "sha256-bVoYRLiK68lI2nHWPY1Dyg1NrpU7ycd/VUTzDvzTJSs=";

  types-aiobotocore-backupstorage =
    buildTypesAiobotocorePackage "backupstorage" "2.13.0"
      "sha256-YUKtBdBrdwL2yqDqOovvzDPbcv/sD8JLRnKz3Oh7iSU=";

  types-aiobotocore-batch =
    buildTypesAiobotocorePackage "batch" "2.25.2"
      "sha256-Z95XnWYb8nDxWsC0SSyC2KHB+zz6m3NuWPkv2b+EovE=";

  types-aiobotocore-billingconductor =
    buildTypesAiobotocorePackage "billingconductor" "2.25.2"
      "sha256-xwVUi04Eq4/HT5G38x1uXrKofRUG6X+Dj1rbWoyt3yA=";

  types-aiobotocore-braket =
    buildTypesAiobotocorePackage "braket" "2.25.2"
      "sha256-h0oHoMOHat1hDr3zplueVpN8dwhTktofv1Pss1nqVPM=";

  types-aiobotocore-budgets =
    buildTypesAiobotocorePackage "budgets" "2.25.2"
      "sha256-JPUgfNM5EjFzfi0TjzlHf3g7tY87w2UXgUMQpaux4Qw=";

  types-aiobotocore-ce =
    buildTypesAiobotocorePackage "ce" "2.25.2"
      "sha256-EDmfPfiwPKmohKDaCy7Br5QFbkgOghj3PuP8MijNCa8=";

  types-aiobotocore-chime =
    buildTypesAiobotocorePackage "chime" "2.25.2"
      "sha256-TjYkrRLpHizqLdtm0+cWdA0hX0aPfCHtjORkfqnc//A=";

  types-aiobotocore-chime-sdk-identity =
    buildTypesAiobotocorePackage "chime-sdk-identity" "2.25.2"
      "sha256-AvCru00Rcjm5q0kcRD/8dCh5ZWwmtX88wZ5L5Rw7PlA=";

  types-aiobotocore-chime-sdk-media-pipelines =
    buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "2.25.2"
      "sha256-5BMPIS1aLSG9YTQqdaaIxFdtKE5LTg105UofjdhypVM=";

  types-aiobotocore-chime-sdk-meetings =
    buildTypesAiobotocorePackage "chime-sdk-meetings" "2.25.2"
      "sha256-ERuzfZzB1DUaEcwv1XJaqOIU3TI5HfgK2SK76O1f340=";

  types-aiobotocore-chime-sdk-messaging =
    buildTypesAiobotocorePackage "chime-sdk-messaging" "2.25.2"
      "sha256-J+YYzAJG1Qu3ghCuI5LT6zc288r2ChCVmetnmCvBNSY=";

  types-aiobotocore-chime-sdk-voice =
    buildTypesAiobotocorePackage "chime-sdk-voice" "2.25.2"
      "sha256-S6lM7Rbnz51wwFd98jrD90dBByFA+/f2OSjtUgWY1W4=";

  types-aiobotocore-cleanrooms =
    buildTypesAiobotocorePackage "cleanrooms" "2.25.2"
      "sha256-mvHayGHokzEyhwwdouuNM9x22bHRBXOQ/cR30Bvhsjw=";

  types-aiobotocore-cloud9 =
    buildTypesAiobotocorePackage "cloud9" "2.25.2"
      "sha256-iaS3NKUf2G3qTwIaDquem196bu+5kTDt8ZRqLzHj+zI=";

  types-aiobotocore-cloudcontrol =
    buildTypesAiobotocorePackage "cloudcontrol" "2.25.2"
      "sha256-UdFZKXNaBoOcBB7Xhdy8+mF8fItSbN5tEEz+ZbTIzC8=";

  types-aiobotocore-clouddirectory =
    buildTypesAiobotocorePackage "clouddirectory" "2.25.2"
      "sha256-hvz3fFknWNzlw9iTnNMjUBqRykMirQkbgIr97l+jjjs=";

  types-aiobotocore-cloudformation =
    buildTypesAiobotocorePackage "cloudformation" "2.25.2"
      "sha256-xLv7qGULxQ6K1SQ91j8dxRTQ8RpVcGGGgKfzDkpbKpA=";

  types-aiobotocore-cloudfront =
    buildTypesAiobotocorePackage "cloudfront" "2.25.2"
      "sha256-+ENxWaoQfraFUn8HDUiIkpOw40/LB7QeFk6hSCF/3y0=";

  types-aiobotocore-cloudhsm =
    buildTypesAiobotocorePackage "cloudhsm" "2.25.2"
      "sha256-ptmTvJkzhhbu4Vrped7frQZH4ycQNLIvTefqm2fCNxQ=";

  types-aiobotocore-cloudhsmv2 =
    buildTypesAiobotocorePackage "cloudhsmv2" "2.25.2"
      "sha256-fL3pDlKrXxvYY29CgAg9mPtsOfA1QPM1oO6aWsXnhqM=";

  types-aiobotocore-cloudsearch =
    buildTypesAiobotocorePackage "cloudsearch" "2.25.2"
      "sha256-73W62nFCs4PSoAPZolcLzrazSqCnszMSt0oZFouiNTM=";

  types-aiobotocore-cloudsearchdomain =
    buildTypesAiobotocorePackage "cloudsearchdomain" "2.25.2"
      "sha256-j55NjUJl4imYkW5HiqC4qlFiDYnGH3oAFhfknNuwey8=";

  types-aiobotocore-cloudtrail =
    buildTypesAiobotocorePackage "cloudtrail" "2.25.2"
      "sha256-Y5QzJ8Sp7o85MZ1KnYQHslcP0O6uXOa8/B4lOPX9x2g=";

  types-aiobotocore-cloudtrail-data =
    buildTypesAiobotocorePackage "cloudtrail-data" "2.25.2"
      "sha256-lSP5vEUV5HcoPXa+pWWjsWShL6siiIbFGpPtBl7wLxc=";

  types-aiobotocore-cloudwatch =
    buildTypesAiobotocorePackage "cloudwatch" "2.25.2"
      "sha256-kNP9fVpYJEiAHOKa9h3HoEn5AqnKthMXw43AIEL99q4=";

  types-aiobotocore-codeartifact =
    buildTypesAiobotocorePackage "codeartifact" "2.25.2"
      "sha256-SRlZBQaa3ormxORXP0RGSZDOvlhYWLt0nGPiODL4YG0=";

  types-aiobotocore-codebuild =
    buildTypesAiobotocorePackage "codebuild" "2.25.2"
      "sha256-MrbRMYgNylPMRxvcja/yIGGlmpeHWT0oNnghhAXcXNw=";

  types-aiobotocore-codecatalyst =
    buildTypesAiobotocorePackage "codecatalyst" "2.25.2"
      "sha256-DMNLQhHJ3nYzVSLt385YrpNdkvZ2H1PKf95FyGJYnqI=";

  types-aiobotocore-codecommit =
    buildTypesAiobotocorePackage "codecommit" "2.25.2"
      "sha256-RMC64Zb8Dfup7xBKgXEF1N+xQKLNd0Ok7hG11cjKpDE=";

  types-aiobotocore-codedeploy =
    buildTypesAiobotocorePackage "codedeploy" "2.25.2"
      "sha256-LdvRhAs3OvRn6P5eayOzxNg65WQ7Bx4MgUPcKzJpNZc=";

  types-aiobotocore-codeguru-reviewer =
    buildTypesAiobotocorePackage "codeguru-reviewer" "2.25.2"
      "sha256-tyGnH4kZW/DuD7LK4BxZ/VJWWqf2K3F2hvySrxkkL0Y=";

  types-aiobotocore-codeguru-security =
    buildTypesAiobotocorePackage "codeguru-security" "2.25.2"
      "sha256-6V2MXIjuFOXQMRaJ0GOZXBn2xHi+lc487xaRFXfKhSo=";

  types-aiobotocore-codeguruprofiler =
    buildTypesAiobotocorePackage "codeguruprofiler" "2.25.2"
      "sha256-hQauCvao281bbAtP2sQXLxncTuQv9MQA5FhNQEjlHrA=";

  types-aiobotocore-codepipeline =
    buildTypesAiobotocorePackage "codepipeline" "2.25.2"
      "sha256-8moeRFg8AR4hpEiVCHf2WjNx92jQQ7b3peiJsPfdp3Q=";

  types-aiobotocore-codestar =
    buildTypesAiobotocorePackage "codestar" "2.13.3"
      "sha256-Z1ewx2RjmxbOQZ7wXaN54PVOuRs6LP3rMpsrVTacwjo=";

  types-aiobotocore-codestar-connections =
    buildTypesAiobotocorePackage "codestar-connections" "2.25.2"
      "sha256-4t7biB4JAOYPrEj1ynAqam6r5Zuh3VIS7Md9NyYQv/k=";

  types-aiobotocore-codestar-notifications =
    buildTypesAiobotocorePackage "codestar-notifications" "2.25.2"
      "sha256-l9mZ6ipzSA6p8pd4QKVqWI5pbLLNGmMBVJjK4NqhJzk=";

  types-aiobotocore-cognito-identity =
    buildTypesAiobotocorePackage "cognito-identity" "2.25.2"
      "sha256-jo3fUFnmH1ntN96nIh1OCkagxzhNRfn3sANtRgcNflU=";

  types-aiobotocore-cognito-idp =
    buildTypesAiobotocorePackage "cognito-idp" "2.25.2"
      "sha256-PSkZx0T6vobbbGZMGc7npUJtO/2zPv7WzttzHj6Tb3w=";

  types-aiobotocore-cognito-sync =
    buildTypesAiobotocorePackage "cognito-sync" "2.25.2"
      "sha256-uTEZdH60rT5iy3tHz30MM12aKXBU3zHaKKEc8Npctbo=";

  types-aiobotocore-comprehend =
    buildTypesAiobotocorePackage "comprehend" "2.25.2"
      "sha256-iICHg2TK4H1tM9A8nrT5L262nvjrNuOBlbnL7rVfQ/0=";

  types-aiobotocore-comprehendmedical =
    buildTypesAiobotocorePackage "comprehendmedical" "2.25.2"
      "sha256-3hSn+3a3f9r6PS9Xe4YZINhL6HvYVNHiHQREuMRwt/I=";

  types-aiobotocore-compute-optimizer =
    buildTypesAiobotocorePackage "compute-optimizer" "2.25.2"
      "sha256-zmVBk4gkorIRKYMpyVFDPoFnjelJg7JJra1LJW4oKKA=";

  types-aiobotocore-config =
    buildTypesAiobotocorePackage "config" "2.25.2"
      "sha256-JJydZdv7myZk4DoDFs01WB6zjLbjYOLykPcm2h4Dxyc=";

  types-aiobotocore-connect =
    buildTypesAiobotocorePackage "connect" "2.25.2"
      "sha256-kd2yClVpJuezDOcreSW1ncTa5yKyt+GVUVIWEVuPWWo=";

  types-aiobotocore-connect-contact-lens =
    buildTypesAiobotocorePackage "connect-contact-lens" "2.25.2"
      "sha256-jj0eSvmA8dQoL/Z9i3Vp9uYgZWTRtesMQprqYSVkPGI=";

  types-aiobotocore-connectcampaigns =
    buildTypesAiobotocorePackage "connectcampaigns" "2.25.2"
      "sha256-P51izlKyq+6fVO3HWD9GI4qdq29+3wRk/0GIzfdMvtM=";

  types-aiobotocore-connectcases =
    buildTypesAiobotocorePackage "connectcases" "2.25.2"
      "sha256-l5Ko3NJdblcilDwGzOIHXaC2NLANYD+nZzQXfbj9+68=";

  types-aiobotocore-connectparticipant =
    buildTypesAiobotocorePackage "connectparticipant" "2.25.2"
      "sha256-33nJKV7Ysvz1rEoNE5ChPXCbKAcn7IfsqkKaEDSqyo0=";

  types-aiobotocore-controltower =
    buildTypesAiobotocorePackage "controltower" "2.25.2"
      "sha256-Gg8X+poQcE9nP1713ZRVQ9gT+pppHoRBxET+RrvkuJI=";

  types-aiobotocore-cur =
    buildTypesAiobotocorePackage "cur" "2.25.2"
      "sha256-ud01zv7990vtVJRfa5j8blXcBmJ/2Vk4NYt2zp339v4=";

  types-aiobotocore-customer-profiles =
    buildTypesAiobotocorePackage "customer-profiles" "2.25.2"
      "sha256-YX10YoQsn/ndErOAAAey+DrJtxv9U79jdQuFRprZLyM=";

  types-aiobotocore-databrew =
    buildTypesAiobotocorePackage "databrew" "2.25.2"
      "sha256-YrBWF10XRXtWKvkUBN51z+6cWqy1McGe4ZyNhVklHBw=";

  types-aiobotocore-dataexchange =
    buildTypesAiobotocorePackage "dataexchange" "2.25.2"
      "sha256-8B/6r7PR/pZNt+vbTfPAVYc1MLdx6uZXgVNwQC/qURY=";

  types-aiobotocore-datapipeline =
    buildTypesAiobotocorePackage "datapipeline" "2.25.2"
      "sha256-OAKDSxCkPK+TMa4o1+iouJDjGxzanzF1A4ubP4ecAkg=";

  types-aiobotocore-datasync =
    buildTypesAiobotocorePackage "datasync" "2.25.2"
      "sha256-Mz8ZXMDAVrh3ABn3JQZhF9XQKIJJDuLvRaRa12lc3EM=";

  types-aiobotocore-dax =
    buildTypesAiobotocorePackage "dax" "2.25.2"
      "sha256-+pyf8C9B6pCC8zxzGjH3LCvcg32KsWoyOinnAQ/49iY=";

  types-aiobotocore-detective =
    buildTypesAiobotocorePackage "detective" "2.25.2"
      "sha256-in6d71h+KK6oYWdcZuWM2VZyTk1wClQliNQXX9PcMkg=";

  types-aiobotocore-devicefarm =
    buildTypesAiobotocorePackage "devicefarm" "2.25.2"
      "sha256-+bHDMOHYq2UR1kgEInmaOdrF37IYGfW2PVsNU8M7whk=";

  types-aiobotocore-devops-guru =
    buildTypesAiobotocorePackage "devops-guru" "2.25.2"
      "sha256-dRbTGobvRbkUu1U07mA7dqTVxw4b1rFHF02BW62ABRk=";

  types-aiobotocore-directconnect =
    buildTypesAiobotocorePackage "directconnect" "2.25.2"
      "sha256-oRHQzv3gfKMorkB9fYcTSDQ0QlpX79QEouU01fLKu7Y=";

  types-aiobotocore-discovery =
    buildTypesAiobotocorePackage "discovery" "2.25.2"
      "sha256-R0uSdznVdJFeS/bAmFMBxfX5mi+VfzzrzQa6516fAZU=";

  types-aiobotocore-dlm =
    buildTypesAiobotocorePackage "dlm" "2.25.2"
      "sha256-KsYxPjxmMOlsNevGUrgxt4NHhsX90U/PFjY6igQFw5g=";

  types-aiobotocore-dms =
    buildTypesAiobotocorePackage "dms" "2.25.2"
      "sha256-E1TzcUsbYJreNjKXfCskkDx7/cf8S11zCdYg2TU1zMA=";

  types-aiobotocore-docdb =
    buildTypesAiobotocorePackage "docdb" "2.25.2"
      "sha256-yNgg6k//9YXSB+DBEpmr1UlwEDDtbvbEWoenxkHoomk=";

  types-aiobotocore-docdb-elastic =
    buildTypesAiobotocorePackage "docdb-elastic" "2.25.2"
      "sha256-qpJkEHKno1Pn0YXUCHPtOC58UFePmz/pHJ55TxHFgYQ=";

  types-aiobotocore-drs =
    buildTypesAiobotocorePackage "drs" "2.25.2"
      "sha256-SkcPhHaKQ9Z7qbvylkB/2ZZGy2/OEHmUAzu3ZjQ5HeM=";

  types-aiobotocore-ds =
    buildTypesAiobotocorePackage "ds" "2.25.2"
      "sha256-iyQEoAjPToWO7AFyb5GPnt3NndhIRC30Wq2Fq3poNRo=";

  types-aiobotocore-dynamodb =
    buildTypesAiobotocorePackage "dynamodb" "2.25.2"
      "sha256-dc/T4+4halnfGBQZXgbNZyPE+IMV2p92+eNyC+X/0s0=";

  types-aiobotocore-dynamodbstreams =
    buildTypesAiobotocorePackage "dynamodbstreams" "2.25.2"
      "sha256-Fhk/vbYOR0gpDe3hTMskto9wh5o3UIqncStU5hvCDF4=";

  types-aiobotocore-ebs =
    buildTypesAiobotocorePackage "ebs" "2.25.2"
      "sha256-A7b6BrPL86JURM9zCBJFuteuBDYqVdX/6cXTUAlwHeQ=";

  types-aiobotocore-ec2 =
    buildTypesAiobotocorePackage "ec2" "2.25.2"
      "sha256-UCcgZHxQW0JA9FMpFdvBapZSBr4cRQcbYhQI16SK274=";

  types-aiobotocore-ec2-instance-connect =
    buildTypesAiobotocorePackage "ec2-instance-connect" "2.25.2"
      "sha256-OSgk3yu88gpj598WGjUThsAGHHvBSVbzuoCCuKskkp4=";

  types-aiobotocore-ecr =
    buildTypesAiobotocorePackage "ecr" "2.25.2"
      "sha256-LX5TAXuncQHfXiRULvbvWhDKcLebePUVtjyONjGEcME=";

  types-aiobotocore-ecr-public =
    buildTypesAiobotocorePackage "ecr-public" "2.25.2"
      "sha256-tyj/+OK76XxBPXb38W9n9LdJITzD5dcfyAAO/zc8Jvs=";

  types-aiobotocore-ecs =
    buildTypesAiobotocorePackage "ecs" "2.25.2"
      "sha256-2+fi0ALJStbYWiy327Qetq5S+zVst+cBzeBgsLN7Sp4=";

  types-aiobotocore-efs =
    buildTypesAiobotocorePackage "efs" "2.25.2"
      "sha256-4trHKR96HIHo2sIJHMNwykgSdlBTec3/KsGQHBD2qgA=";

  types-aiobotocore-eks =
    buildTypesAiobotocorePackage "eks" "2.25.2"
      "sha256-PGFzPj9Yj+MYKOGUcfifLqR48HzyiCaqpcrDAphA4pU=";

  types-aiobotocore-elastic-inference =
    buildTypesAiobotocorePackage "elastic-inference" "2.20.0"
      "sha256-jFSY7JBVjDQi6dCqlX2LG7jxpSKfILv3XWbYidvtGos=";

  types-aiobotocore-elasticache =
    buildTypesAiobotocorePackage "elasticache" "2.25.2"
      "sha256-OBxp5BxcRQnDUUmDd6rboq3C4Oi0p5aStqoFMCgdXkc=";

  types-aiobotocore-elasticbeanstalk =
    buildTypesAiobotocorePackage "elasticbeanstalk" "2.25.2"
      "sha256-Kx9/13qjDSznU/vFpOMn2uIfmv+TZ7qP5dyI6locQVo=";

  types-aiobotocore-elastictranscoder =
    buildTypesAiobotocorePackage "elastictranscoder" "2.25.2"
      "sha256-5t214U60d2kSf8bmUiEkj4OMFf3+SbNRGqLif1Rj28E=";

  types-aiobotocore-elb =
    buildTypesAiobotocorePackage "elb" "2.25.2"
      "sha256-kw5WvoEdWSosiqInf4UYu+KiT/VbQV1nVEO8MwhAKaU=";

  types-aiobotocore-elbv2 =
    buildTypesAiobotocorePackage "elbv2" "2.25.2"
      "sha256-40bV+lL65lvnkmVCXKD+F7sWa3sn+aee75pYpqlze0w=";

  types-aiobotocore-emr =
    buildTypesAiobotocorePackage "emr" "2.25.2"
      "sha256-GKDnn+q3KHpgWnJVdCQ6/TcCvEKOKEnFuvp9EIIBS2w=";

  types-aiobotocore-emr-containers =
    buildTypesAiobotocorePackage "emr-containers" "2.25.2"
      "sha256-uzaxAAoS2b2IrsSzrdoPTopLRE9x4kXu+I+DGqfbO2U=";

  types-aiobotocore-emr-serverless =
    buildTypesAiobotocorePackage "emr-serverless" "2.25.2"
      "sha256-2aiEQtEv0nLjFJWaAUe/E4blpBboZDAW9+upmhlZCoY=";

  types-aiobotocore-entityresolution =
    buildTypesAiobotocorePackage "entityresolution" "2.25.2"
      "sha256-zJzRxpm7uagRwfLdwt/tS3pdLGpECMuZXitq7MDDzI4=";

  types-aiobotocore-es =
    buildTypesAiobotocorePackage "es" "2.25.2"
      "sha256-NK+YUpC75lpC4nWox1CpG4cmJJK5wx8uwC1vy8H/Z94=";

  types-aiobotocore-events =
    buildTypesAiobotocorePackage "events" "2.25.2"
      "sha256-U2cdpbAE496OkkvikFkseVh+OegBTlwpv5nqRnY2YU4=";

  types-aiobotocore-evidently =
    buildTypesAiobotocorePackage "evidently" "2.25.2"
      "sha256-qAs/EJou4PBT/in0w8JDMWhsIxZgvPiZGKuPTNQUUCQ=";

  types-aiobotocore-finspace =
    buildTypesAiobotocorePackage "finspace" "2.25.2"
      "sha256-DnMewOnAHJf+ExZwlLKJIz785Sr4SQt22wB54cfIA08=";

  types-aiobotocore-finspace-data =
    buildTypesAiobotocorePackage "finspace-data" "2.25.2"
      "sha256-xNLAi3IacbqeSj9Tc6tuM8cFYXV9LTrVMMrMuOaHoYI=";

  types-aiobotocore-firehose =
    buildTypesAiobotocorePackage "firehose" "2.25.2"
      "sha256-Uat0v5pcM7UHQWzdNfFT+PlBNQ3ctwnqHZe9MH31MjU=";

  types-aiobotocore-fis =
    buildTypesAiobotocorePackage "fis" "2.25.2"
      "sha256-mhXOn6NpHXkyNlljoLztMzCUlJnq/4S2RoanP4rkZ50=";

  types-aiobotocore-fms =
    buildTypesAiobotocorePackage "fms" "2.25.2"
      "sha256-dKi7CgYbsJUvVfCE0RS3cLqI/iJSx1wf3aYtLCUTZ0c=";

  types-aiobotocore-forecast =
    buildTypesAiobotocorePackage "forecast" "2.25.2"
      "sha256-t38/Zmq8LsHTYPvVBNvfKOFsJh1H8mTNpOuAOfn268o=";

  types-aiobotocore-forecastquery =
    buildTypesAiobotocorePackage "forecastquery" "2.25.2"
      "sha256-unT0W95NPPdCaQaXbmodcRNLUtla6nFQ9XsLTaF8jLw=";

  types-aiobotocore-frauddetector =
    buildTypesAiobotocorePackage "frauddetector" "2.25.2"
      "sha256-6hUMCYRPfQPk+ufDNEeQL/vI8tSuzWu1YRdfsBBSLRc=";

  types-aiobotocore-fsx =
    buildTypesAiobotocorePackage "fsx" "2.25.2"
      "sha256-kEeOKl23sv9KJoq3Si9b/pHS7XL65Nq1mal/ogmikYg=";

  types-aiobotocore-gamelift =
    buildTypesAiobotocorePackage "gamelift" "2.25.2"
      "sha256-vsYGOElYaWo6ogenqYr6PnHtluMXnFDscrQXB0nPD1s=";

  types-aiobotocore-gamesparks =
    buildTypesAiobotocorePackage "gamesparks" "2.7.0"
      "sha256-oVbKtuLMPpCQcZYx/cH1Dqjv/t6/uXsveflfFVqfN+8=";

  types-aiobotocore-glacier =
    buildTypesAiobotocorePackage "glacier" "2.25.2"
      "sha256-rvNIShaXuazqjXpmNJOkzvYQgz9RL4EYatCjAbgKCI0=";

  types-aiobotocore-globalaccelerator =
    buildTypesAiobotocorePackage "globalaccelerator" "2.25.2"
      "sha256-070hbQGvK+Zu3ChPBAOfkm2EehOEfj60ieo/xXUWV0U=";

  types-aiobotocore-glue =
    buildTypesAiobotocorePackage "glue" "2.25.2"
      "sha256-rBTwtr0klPbQ6+mC15Fj/yItNsJu0FhDSYXLMga83pQ=";

  types-aiobotocore-grafana =
    buildTypesAiobotocorePackage "grafana" "2.25.2"
      "sha256-sRHDeDpnfhwk4LQjeouOPzmZUL7M2jY54cBg6TRgNoY=";

  types-aiobotocore-greengrass =
    buildTypesAiobotocorePackage "greengrass" "2.25.2"
      "sha256-/0uklw1i2EY6WzzTxLIqgorhQoljyU9IRxuzQjh1W8Q=";

  types-aiobotocore-greengrassv2 =
    buildTypesAiobotocorePackage "greengrassv2" "2.25.2"
      "sha256-G9cJzBWFap+aiq/+SO/AvHJPv3W0dW0VsGmxCnzZWeQ=";

  types-aiobotocore-groundstation =
    buildTypesAiobotocorePackage "groundstation" "2.25.2"
      "sha256-skdsb8uGe9r7UQZWxlNeWXxkMlQYbAtQ60xAvBVpXBQ=";

  types-aiobotocore-guardduty =
    buildTypesAiobotocorePackage "guardduty" "2.25.2"
      "sha256-1cjUwVNQgl1gyI+pALGpbytjfkrET4l8rxqreQZjAaU=";

  types-aiobotocore-health =
    buildTypesAiobotocorePackage "health" "2.25.2"
      "sha256-2EoAh3qXl2B5xpL3O8Kh+LGpmJypD+EdMk0DLSC4x30=";

  types-aiobotocore-healthlake =
    buildTypesAiobotocorePackage "healthlake" "2.25.2"
      "sha256-SA/SsA9dN5z0pZU7CSDUgtAfC2KL6okJNYYEyRCBXBs=";

  types-aiobotocore-honeycode =
    buildTypesAiobotocorePackage "honeycode" "2.13.0"
      "sha256-DeeheoQeFEcDH21DSNs2kSR1rjnPLtTgz0yNCFnE+Io=";

  types-aiobotocore-iam =
    buildTypesAiobotocorePackage "iam" "2.25.2"
      "sha256-qxr8H+75b5joWgYD5OngJAvowvE1emfiOCDwf+imVs0=";

  types-aiobotocore-identitystore =
    buildTypesAiobotocorePackage "identitystore" "2.25.2"
      "sha256-olypKwxXq7blgh1KxnFjPOQ2LsJGdyr5wtjlI7GCk4g=";

  types-aiobotocore-imagebuilder =
    buildTypesAiobotocorePackage "imagebuilder" "2.25.2"
      "sha256-lkyF1sTuKEpGk5D5hu4D22JGTtl2jdLKPYjWOcdoKcM=";

  types-aiobotocore-importexport =
    buildTypesAiobotocorePackage "importexport" "2.25.2"
      "sha256-C+EfG+E6ssDSbAEUeZJj7boV8LbBNiP8IqxGe9wBeyo=";

  types-aiobotocore-inspector =
    buildTypesAiobotocorePackage "inspector" "2.25.2"
      "sha256-E0kpaswtjZuja4oadv6mfOVBx7V9rzmLVOj/9I6HOgI=";

  types-aiobotocore-inspector2 =
    buildTypesAiobotocorePackage "inspector2" "2.25.2"
      "sha256-W5iQ9DMwhKRFb/GlXCd/1ikTYIQmc5LDk1tlFmioLSc=";

  types-aiobotocore-internetmonitor =
    buildTypesAiobotocorePackage "internetmonitor" "2.25.2"
      "sha256-lp/NFksSRfiVyA28/q179XmP1b2519cJqMcOGszG0sM=";

  types-aiobotocore-iot =
    buildTypesAiobotocorePackage "iot" "2.25.2"
      "sha256-5riC4MVTOeoWOTkG9KfZv7pqrus8zoUJjwmgBTTNnLY=";

  types-aiobotocore-iot-data =
    buildTypesAiobotocorePackage "iot-data" "2.25.2"
      "sha256-g6wLfpVAeNwN8lTEd3WldKzyCdTcVVxJtAMGlsvJXyo=";

  types-aiobotocore-iot-jobs-data =
    buildTypesAiobotocorePackage "iot-jobs-data" "2.25.2"
      "sha256-bNem7hNY+n8YyWRHfla3XrIIjQ2XtYNj2lXswGU4E5A=";

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
    buildTypesAiobotocorePackage "iotanalytics" "2.25.2"
      "sha256-1WvVA00h5geNrEHppF7Hi15j+8STdQCE77I/4egS168=";

  types-aiobotocore-iotdeviceadvisor =
    buildTypesAiobotocorePackage "iotdeviceadvisor" "2.25.2"
      "sha256-MbYARIi0FUixr0BrOx8i2zkQ5ScNl2JekXKqFR6AJzI=";

  types-aiobotocore-iotevents =
    buildTypesAiobotocorePackage "iotevents" "2.25.2"
      "sha256-nOA2CgNX8FMkkAnvdKx+1cJ2J6oVpA/SzQqhbW939zM=";

  types-aiobotocore-iotevents-data =
    buildTypesAiobotocorePackage "iotevents-data" "2.25.2"
      "sha256-zJWDinktOdzVwFRDvhe2oJ60a+0ornkuZmFFIEHG1LU=";

  types-aiobotocore-iotfleethub =
    buildTypesAiobotocorePackage "iotfleethub" "2.24.2"
      "sha256-WzdCGMVRCl8x+UswlyApMYMYT3Rvtng0ID2YyV08NzA=";

  types-aiobotocore-iotfleetwise =
    buildTypesAiobotocorePackage "iotfleetwise" "2.25.2"
      "sha256-dfs2kqZud8YyuKJ7h5f5FOaepAbgwyuVxPf2BsTv8ng=";

  types-aiobotocore-iotsecuretunneling =
    buildTypesAiobotocorePackage "iotsecuretunneling" "2.25.2"
      "sha256-xiDy1kKgS/f1FJh2NqNe5L8f0xmzZwpyUaRoCuP6VRc=";

  types-aiobotocore-iotsitewise =
    buildTypesAiobotocorePackage "iotsitewise" "2.25.2"
      "sha256-ZwnG/eOWi6uvWx9grxW6OBsIaf+Kf3vEl2P+RlCtjL4=";

  types-aiobotocore-iotthingsgraph =
    buildTypesAiobotocorePackage "iotthingsgraph" "2.25.2"
      "sha256-+2aoGkoFdsT16dpHqxnLkB1JOk8CdEkTbPeT2ft8EbY=";

  types-aiobotocore-iottwinmaker =
    buildTypesAiobotocorePackage "iottwinmaker" "2.25.2"
      "sha256-VmLslrYD8bZXjYAiup5Ym55ZnUxgaC2BIu4tdop+y/0=";

  types-aiobotocore-iotwireless =
    buildTypesAiobotocorePackage "iotwireless" "2.25.2"
      "sha256-GT7wWOP1X/rrAbCRAiiTgKNwXlvjf3RSOQ6GcwIrFgw=";

  types-aiobotocore-ivs =
    buildTypesAiobotocorePackage "ivs" "2.25.2"
      "sha256-MJlGDg4v0RSJ3rvF7i1rxtgdI3pjr0IcJZsrmP3DHDE=";

  types-aiobotocore-ivs-realtime =
    buildTypesAiobotocorePackage "ivs-realtime" "2.25.2"
      "sha256-kohM7k5ybZtI1adzTvY/f66QUVmYC4P1YmLz2nlzHv4=";

  types-aiobotocore-ivschat =
    buildTypesAiobotocorePackage "ivschat" "2.25.2"
      "sha256-mt0mckRiQlBFYgUvXptSHVPVI+xdaNrOFdNEHzy9eEI=";

  types-aiobotocore-kafka =
    buildTypesAiobotocorePackage "kafka" "2.25.2"
      "sha256-oDPmGo/sQb9JzKpmR/vDVHKdBmjqoZggxYloXE8sO0c=";

  types-aiobotocore-kafkaconnect =
    buildTypesAiobotocorePackage "kafkaconnect" "2.25.2"
      "sha256-0HC7FMCn9WfiyZjCwWUnWcDq/Y9QqyzXnmNe4wqwpqk=";

  types-aiobotocore-kendra =
    buildTypesAiobotocorePackage "kendra" "2.25.2"
      "sha256-9hoLqHHyM5ApiZF46j4TQftcsxflpgmeowV7vs8AFbc=";

  types-aiobotocore-kendra-ranking =
    buildTypesAiobotocorePackage "kendra-ranking" "2.25.2"
      "sha256-Mt1jTUTHmLJnVL+hGYpqSqdGq2DEJBkMJzVS5ukaFDQ=";

  types-aiobotocore-keyspaces =
    buildTypesAiobotocorePackage "keyspaces" "2.25.2"
      "sha256-L8VS25Bp36xluWUs9QoVE/qRAXrqsCD27R2LSPLmruE=";

  types-aiobotocore-kinesis =
    buildTypesAiobotocorePackage "kinesis" "2.25.2"
      "sha256-mCFqvsi+1PW3VwALLkykyfISkXVEX7HCfDgJIZQzdvo=";

  types-aiobotocore-kinesis-video-archived-media =
    buildTypesAiobotocorePackage "kinesis-video-archived-media" "2.25.2"
      "sha256-5kFLsQQZi9VhBWJiVKjTgFr9Gio59Y5AhUf5294MySU=";

  types-aiobotocore-kinesis-video-media =
    buildTypesAiobotocorePackage "kinesis-video-media" "2.25.2"
      "sha256-nb9TVdiEVlPy+mLYivALEUZgfhYqYGJjFRqMo6fp3Wc=";

  types-aiobotocore-kinesis-video-signaling =
    buildTypesAiobotocorePackage "kinesis-video-signaling" "2.25.2"
      "sha256-ApCbbCWPFEuw74dMKxqPNCknDf+zgBcnnvP3q+hq3os=";

  types-aiobotocore-kinesis-video-webrtc-storage =
    buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "2.25.2"
      "sha256-TDawYu1ExF3mMen9eNCiY1UMixdZ5K0WhHWHGfvKhOU=";

  types-aiobotocore-kinesisanalytics =
    buildTypesAiobotocorePackage "kinesisanalytics" "2.25.2"
      "sha256-CQXuj7d21j6VDF5vE3FzAGOtYIneFAJiL7ioDJsg+UY=";

  types-aiobotocore-kinesisanalyticsv2 =
    buildTypesAiobotocorePackage "kinesisanalyticsv2" "2.25.2"
      "sha256-XHF4hST83t8R/TbfOBVXP5lMuQClES+XaKf7KSauH/g=";

  types-aiobotocore-kinesisvideo =
    buildTypesAiobotocorePackage "kinesisvideo" "2.25.2"
      "sha256-hnS3pir4ObjSzwpOKdOL6Z13SKFooRYL7LAePK3gzxs=";

  types-aiobotocore-kms =
    buildTypesAiobotocorePackage "kms" "2.25.2"
      "sha256-4+ZRU+rDGLge2OLJqpD65R4nR4lp4RqDQsMJ12vX0AI=";

  types-aiobotocore-lakeformation =
    buildTypesAiobotocorePackage "lakeformation" "2.25.2"
      "sha256-DlrQ9PobstugpGPFYDI+qmUdJXSEtJOT1TUS/pzzP70=";

  types-aiobotocore-lambda =
    buildTypesAiobotocorePackage "lambda" "2.25.2"
      "sha256-WkUkI9LAWLORwuQ8gJH7l92Alcz/1+6WZIgw0bznB/o=";

  types-aiobotocore-lex-models =
    buildTypesAiobotocorePackage "lex-models" "2.25.2"
      "sha256-vh9YBdvDuN9P/18SRJEkw4u2iHGWZcNXzJFxhmfIzEQ=";

  types-aiobotocore-lex-runtime =
    buildTypesAiobotocorePackage "lex-runtime" "2.25.2"
      "sha256-8lplzdiDbe6ugflU6B2399wpnWn1/02PxfD3Y1Nfcyo=";

  types-aiobotocore-lexv2-models =
    buildTypesAiobotocorePackage "lexv2-models" "2.25.2"
      "sha256-ERcdhhhV3smH4ldT3RXggbUTpyIrhdWN4AOtM+yEBLg=";

  types-aiobotocore-lexv2-runtime =
    buildTypesAiobotocorePackage "lexv2-runtime" "2.25.2"
      "sha256-w94hz4nxE9bOef6/sUHJ98brAHYEbeMqsJrNnhAGBsk=";

  types-aiobotocore-license-manager =
    buildTypesAiobotocorePackage "license-manager" "2.25.2"
      "sha256-wYdKQouFpqYSwJnhODLRq85RijCfi0NyZ9QfblUw3LE=";

  types-aiobotocore-license-manager-linux-subscriptions =
    buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "2.25.2"
      "sha256-iYdFS/wK8w/8k4U4HHIywdWfrndqIiW8fORPeAscpoE=";

  types-aiobotocore-license-manager-user-subscriptions =
    buildTypesAiobotocorePackage "license-manager-user-subscriptions" "2.25.2"
      "sha256-lnE4SloS8g7lDE0x5Q+qCITeyLrcGRwI+6lZBcIGH2w=";

  types-aiobotocore-lightsail =
    buildTypesAiobotocorePackage "lightsail" "2.25.2"
      "sha256-+G/8W+9NbMbJT0oy8pLmSJLF7vtG2HplKya8bzCm2+c=";

  types-aiobotocore-location =
    buildTypesAiobotocorePackage "location" "2.25.2"
      "sha256-8uIByz83NRpkCJl2Wff82hm9vWW/0HLcHq9ypeKuDXo=";

  types-aiobotocore-logs =
    buildTypesAiobotocorePackage "logs" "2.25.2"
      "sha256-h4gPST8V8xHEIbj4TMBdN6xREBfqnfgMYeuKCzoLffY=";

  types-aiobotocore-lookoutequipment =
    buildTypesAiobotocorePackage "lookoutequipment" "2.25.2"
      "sha256-GPLq/zfOTWA9E2a/eSWFuGaHyZSgahG28NuIOHfoTMk=";

  types-aiobotocore-lookoutmetrics =
    buildTypesAiobotocorePackage "lookoutmetrics" "2.24.2"
      "sha256-u84KeWwmp42KajZ3HnztG1106RN4dGh3jcMfSkJYXNY=";

  types-aiobotocore-lookoutvision =
    buildTypesAiobotocorePackage "lookoutvision" "2.24.2"
      "sha256-HvNqynXLpYFJceCmrlncodqWuoczilMB8QtbCS5pcDM=";

  types-aiobotocore-m2 =
    buildTypesAiobotocorePackage "m2" "2.25.2"
      "sha256-YbWneWHZ/Ec/bnLTdOGQEAmabSPZ0aP2+9Ant+mWO1g=";

  types-aiobotocore-machinelearning =
    buildTypesAiobotocorePackage "machinelearning" "2.25.2"
      "sha256-S5y7vhPepXu4r4bsSXJakD6yZxgLSLhDhwpbG0NXqn0=";

  types-aiobotocore-macie =
    buildTypesAiobotocorePackage "macie" "2.7.0"
      "sha256-hJJtGsK2b56nKX1ZhiarC+ffyjHYWRiC8II4oyDZWWw=";

  types-aiobotocore-macie2 =
    buildTypesAiobotocorePackage "macie2" "2.25.2"
      "sha256-qIvrKot9j/V5Ze41i8969zJ2fTFghJciMpFcvUMUaNE=";

  types-aiobotocore-managedblockchain =
    buildTypesAiobotocorePackage "managedblockchain" "2.25.2"
      "sha256-qyceXJgZ7WBPrLx6qhX+Hjy6Gn+ZvhlTaUBdMc52hH0=";

  types-aiobotocore-managedblockchain-query =
    buildTypesAiobotocorePackage "managedblockchain-query" "2.25.2"
      "sha256-6RHcu96TCIavgycEbYM4Q9suVDd3TDO0DvyqcK5VOMo=";

  types-aiobotocore-marketplace-catalog =
    buildTypesAiobotocorePackage "marketplace-catalog" "2.25.2"
      "sha256-qj3TSjteoHDDQAdy55D6cJhH05PUZplNt/zxHh2fEBo=";

  types-aiobotocore-marketplace-entitlement =
    buildTypesAiobotocorePackage "marketplace-entitlement" "2.25.2"
      "sha256-DRKMayesiEf1sOcfnoxGF8vPY/uX0rpYufUYiJUQSVs=";

  types-aiobotocore-marketplacecommerceanalytics =
    buildTypesAiobotocorePackage "marketplacecommerceanalytics" "2.25.2"
      "sha256-qxtdh9tSI4hpRq3jBU6JxvqSu3YkTbHhMxJ1ekQx9JU=";

  types-aiobotocore-mediaconnect =
    buildTypesAiobotocorePackage "mediaconnect" "2.25.2"
      "sha256-aDGNCaBg0o4wNFRyKUUWWraybEZeelFd8XKl70RpQtQ=";

  types-aiobotocore-mediaconvert =
    buildTypesAiobotocorePackage "mediaconvert" "2.25.2"
      "sha256-At89/Du/ui/NM1WeQomgur8VF4hS/vyzt2mD1LysWHU=";

  types-aiobotocore-medialive =
    buildTypesAiobotocorePackage "medialive" "2.25.2"
      "sha256-anrK2JZmOh4WZ543bh2RCbuELbuhvEOXtYbGhZ/UqrA=";

  types-aiobotocore-mediapackage =
    buildTypesAiobotocorePackage "mediapackage" "2.25.2"
      "sha256-E3jZUhnUKvhneoCay65koa+T6mbua1Lbax6kBjrItx4=";

  types-aiobotocore-mediapackage-vod =
    buildTypesAiobotocorePackage "mediapackage-vod" "2.25.2"
      "sha256-uL4hVr/G00kA7wG+atjbn1lLLoTV0AnXYYDluCfSmqE=";

  types-aiobotocore-mediapackagev2 =
    buildTypesAiobotocorePackage "mediapackagev2" "2.25.2"
      "sha256-tZCiBFSee+6HplPoPHoVMaR0XrvKZtlWKzVqlXkdW5k=";

  types-aiobotocore-mediastore =
    buildTypesAiobotocorePackage "mediastore" "2.25.2"
      "sha256-7ANK/FhmUkUUUreA4xLJAqYI53ioFO07kDNHLYkyBlU=";

  types-aiobotocore-mediastore-data =
    buildTypesAiobotocorePackage "mediastore-data" "2.25.2"
      "sha256-XFex66jlYRKiCfRdiZVX28QwXe8+PC2uB5LM+8mOfiw=";

  types-aiobotocore-mediatailor =
    buildTypesAiobotocorePackage "mediatailor" "2.25.2"
      "sha256-COlacwu57atUhHwb157igyHuqh2XazkBpSVh91z4nAw=";

  types-aiobotocore-medical-imaging =
    buildTypesAiobotocorePackage "medical-imaging" "2.25.2"
      "sha256-NHoq/spW3VagYD79oHmdJWvie0+8xosoOMekLZVwQQA=";

  types-aiobotocore-memorydb =
    buildTypesAiobotocorePackage "memorydb" "2.25.2"
      "sha256-/59U+2UMahLGM8GqafX2ZPxrA7rIT4Z9qwNDW3zmKxY=";

  types-aiobotocore-meteringmarketplace =
    buildTypesAiobotocorePackage "meteringmarketplace" "2.25.2"
      "sha256-PpQcRmsKJ/hQwg/5heNMnpODolJful2lloGZaf0pQLE=";

  types-aiobotocore-mgh =
    buildTypesAiobotocorePackage "mgh" "2.25.2"
      "sha256-KdrWfPA/CicV8vNUjnrw/5w9QKda1sA1gXwiz7umR/o=";

  types-aiobotocore-mgn =
    buildTypesAiobotocorePackage "mgn" "2.25.2"
      "sha256-nBPit2aPt6Zs9AQmji828swj1A9L5W3olAc95fTQl3s=";

  types-aiobotocore-migration-hub-refactor-spaces =
    buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "2.25.2"
      "sha256-XTHyGqOf67eu+bzyx0l+UpgIIA5uHfyltglvjhsD2l0=";

  types-aiobotocore-migrationhub-config =
    buildTypesAiobotocorePackage "migrationhub-config" "2.25.2"
      "sha256-8q5MpnVx1zo1C4Olk93vFw8pHhVQ7jRlfX1nyIBZBzw=";

  types-aiobotocore-migrationhuborchestrator =
    buildTypesAiobotocorePackage "migrationhuborchestrator" "2.25.2"
      "sha256-njVMttM0+1igXhrM3OIUTLv+97K4/Ast1NFwzFvAVCM=";

  types-aiobotocore-migrationhubstrategy =
    buildTypesAiobotocorePackage "migrationhubstrategy" "2.25.2"
      "sha256-PREO7b44lmLvdug5wuQaKskllldvil1q8gDYT3kJjoQ=";

  types-aiobotocore-mobile =
    buildTypesAiobotocorePackage "mobile" "2.13.2"
      "sha256-OxB91BCAmYnY72JBWZaBlEkpAxN2Q5aY4i1Pt3eD9hc=";

  types-aiobotocore-mq =
    buildTypesAiobotocorePackage "mq" "2.25.2"
      "sha256-AwInW1TGOr0n0TUYizaSQ0o9Y6ckmmmep6mAh6XW+Bo=";

  types-aiobotocore-mturk =
    buildTypesAiobotocorePackage "mturk" "2.25.2"
      "sha256-HbrgZBxr2QtDwJgd42zZV+4BoRtYsri6lYe2oYWnwMs=";

  types-aiobotocore-mwaa =
    buildTypesAiobotocorePackage "mwaa" "2.25.2"
      "sha256-6+pGFAX1sTopVOBq1eRM9c154OB7zFHP3aKjSzLSjcc=";

  types-aiobotocore-neptune =
    buildTypesAiobotocorePackage "neptune" "2.25.2"
      "sha256-Zpl4Anrfd58nH8vkgnFA6qLlVZkG4ZEqBn5vW6ZXQOA=";

  types-aiobotocore-network-firewall =
    buildTypesAiobotocorePackage "network-firewall" "2.25.2"
      "sha256-/7j4x/JPaKBhHo7yN2wkPMbg9qLRPHTwlRO+6Gkc6Lg=";

  types-aiobotocore-networkmanager =
    buildTypesAiobotocorePackage "networkmanager" "2.25.2"
      "sha256-ZiIH0oKyydgSqE7FaI2xKjdNKK+5mskPc1NytqVw5js=";

  types-aiobotocore-nimble =
    buildTypesAiobotocorePackage "nimble" "2.15.2"
      "sha256-PChX5Jbgr0d1YaTZU9AbX3cM7NrhkyunK6/X3l+I8Q0=";

  types-aiobotocore-oam =
    buildTypesAiobotocorePackage "oam" "2.25.2"
      "sha256-w3SEOR6BQSA5ckP9HROOR4cAbo2+4D0hEZi26pCNMnU=";

  types-aiobotocore-omics =
    buildTypesAiobotocorePackage "omics" "2.25.2"
      "sha256-PAG9T7YOsYdtWjZvUxNUIYnWYrizZHpmH78ayWmTCKY=";

  types-aiobotocore-opensearch =
    buildTypesAiobotocorePackage "opensearch" "2.25.2"
      "sha256-5nRwfDho/9yvcH0dYpxeCzVIQrF9J9dnv5Qm4WvZ5zA=";

  types-aiobotocore-opensearchserverless =
    buildTypesAiobotocorePackage "opensearchserverless" "2.25.2"
      "sha256-saBUVPlT3ODQJ7Jk5G71R7Qq7/L14qtXnRMcCd+0OY4=";

  types-aiobotocore-opsworks =
    buildTypesAiobotocorePackage "opsworks" "2.24.2"
      "sha256-ScEMFhogJRX6ykymK3rqYniGVcyJEsECKvnnbT3xv1A=";

  types-aiobotocore-opsworkscm =
    buildTypesAiobotocorePackage "opsworkscm" "2.24.2"
      "sha256-i+qoE5XXWpZ7dQeDagkD2MhnBjwbKTJYyZxATDh8h9M=";

  types-aiobotocore-organizations =
    buildTypesAiobotocorePackage "organizations" "2.25.2"
      "sha256-dO8JE2pbNt6rDAuHiwbMuTg2V0fKCGjc6d/Cd3OVhUQ=";

  types-aiobotocore-osis =
    buildTypesAiobotocorePackage "osis" "2.25.2"
      "sha256-0nk0lMWUbuINhT60pLowKwAaOGQbd/9sf7wEj2lNhl0=";

  types-aiobotocore-outposts =
    buildTypesAiobotocorePackage "outposts" "2.25.2"
      "sha256-c/1DDIt+MBMt09ZZHMAnvG81lDq9AFisbIWIBG6D5MQ=";

  types-aiobotocore-panorama =
    buildTypesAiobotocorePackage "panorama" "2.25.2"
      "sha256-Zv0yeFB5IpB3kqlOowfNswR+G5OX82OJBt1QUisDlos=";

  types-aiobotocore-payment-cryptography =
    buildTypesAiobotocorePackage "payment-cryptography" "2.25.2"
      "sha256-KrTughOEYCqNpOv/Y2jmJfRexOrzV5yJomLPTQRdXjs=";

  types-aiobotocore-payment-cryptography-data =
    buildTypesAiobotocorePackage "payment-cryptography-data" "2.25.2"
      "sha256-jzGSwUw5gsrr+1tu3+Rdo1K0d5AqmcUUI8nolCOT4bU=";

  types-aiobotocore-personalize =
    buildTypesAiobotocorePackage "personalize" "2.25.2"
      "sha256-8spaqQ+k5d7WGon8CiJ5LgbhsZBGexTHby5YGnL1a4U=";

  types-aiobotocore-personalize-events =
    buildTypesAiobotocorePackage "personalize-events" "2.25.2"
      "sha256-s1GQchI2rx+ajsA5UENZVWo9KY1GMdUMDpLt7ePGImg=";

  types-aiobotocore-personalize-runtime =
    buildTypesAiobotocorePackage "personalize-runtime" "2.25.2"
      "sha256-bhEeoFRrlzCM9FoulsT/DRkye/pfFIrn4dzk30s2RKQ=";

  types-aiobotocore-pi =
    buildTypesAiobotocorePackage "pi" "2.25.2"
      "sha256-OUd0S5oRAdGqeajxHX59x25igGgFIhr7yAHMYqsQh1M=";

  types-aiobotocore-pinpoint =
    buildTypesAiobotocorePackage "pinpoint" "2.25.2"
      "sha256-M2sQEvHFE0vV1l1eePhb54HGsJ2RrkaK2M9J0IVlfX8=";

  types-aiobotocore-pinpoint-email =
    buildTypesAiobotocorePackage "pinpoint-email" "2.25.2"
      "sha256-ZnMOcODdmzB/N6QCmCOSAyL2CXss1GcOU+Fh9Wyh+5g=";

  types-aiobotocore-pinpoint-sms-voice =
    buildTypesAiobotocorePackage "pinpoint-sms-voice" "2.25.2"
      "sha256-6F3QLsaPLU4BBtaONj2lKedt8oYaj+gAb1YUvwcmbzg=";

  types-aiobotocore-pinpoint-sms-voice-v2 =
    buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "2.25.2"
      "sha256-j7BCnRMXe9+d0kRJVaYEr54Bo+ujjS1Hi1yfjHCBkdE=";

  types-aiobotocore-pipes =
    buildTypesAiobotocorePackage "pipes" "2.25.2"
      "sha256-3FqyC9tFQz0ZEW3TBgN5lHeaY5dCNnpIwxi7z+BL0hc=";

  types-aiobotocore-polly =
    buildTypesAiobotocorePackage "polly" "2.25.2"
      "sha256-DIlOVgsbGsqMsAQRwr/YmDD/lW2UUyjLNppMn9VtfoU=";

  types-aiobotocore-pricing =
    buildTypesAiobotocorePackage "pricing" "2.25.2"
      "sha256-aSteb3n8TbdQxdOvmVRRcuwCRq6IE1/trY3wBuDW4io=";

  types-aiobotocore-privatenetworks =
    buildTypesAiobotocorePackage "privatenetworks" "2.22.0"
      "sha256-yaYvgVKcr3l2eq0dMzmQEZHxgblTLlVF9cZRnObiB7M=";

  types-aiobotocore-proton =
    buildTypesAiobotocorePackage "proton" "2.25.2"
      "sha256-JnoxcrN0S/qZ3mhVqKxY7Nbf3kegEx5Xnc6ZxUKeeyE=";

  types-aiobotocore-qldb =
    buildTypesAiobotocorePackage "qldb" "2.24.2"
      "sha256-qrSbXgc4DBb2kNg0ydb1vT9EmRqQWNIfuNOVsK8BPY0=";

  types-aiobotocore-qldb-session =
    buildTypesAiobotocorePackage "qldb-session" "2.24.2"
      "sha256-Lk9RLigcg4F/AsgKneBUoyPyeUh46ra+BLCw94b74eU=";

  types-aiobotocore-quicksight =
    buildTypesAiobotocorePackage "quicksight" "2.25.2"
      "sha256-HnGgyqUvB+hjpqWPU24TAr5kJCYcPls9TsCqsXbWdcY=";

  types-aiobotocore-ram =
    buildTypesAiobotocorePackage "ram" "2.25.2"
      "sha256-y4KEJDBFOwbSGuMdIhkb2ZK9Gh7axRBBaKcStagc6Ek=";

  types-aiobotocore-rbin =
    buildTypesAiobotocorePackage "rbin" "2.25.2"
      "sha256-WfqcriciQKLy4gQFNTbBU65R6b9o+WU2rPbVORigzh4=";

  types-aiobotocore-rds =
    buildTypesAiobotocorePackage "rds" "2.25.2"
      "sha256-BQ9R+G5QcH3iViK79qJ6s658fikXmKESHzkqjDz3i2M=";

  types-aiobotocore-rds-data =
    buildTypesAiobotocorePackage "rds-data" "2.25.2"
      "sha256-1hTSDOuk6kkscJJMSpxtzv+Yq842JC693qUULggw77g=";

  types-aiobotocore-redshift =
    buildTypesAiobotocorePackage "redshift" "2.25.2"
      "sha256-o69QtsQL6+hicLZrEl9Ws6be8jYk38rS2qyFzKG8vnM=";

  types-aiobotocore-redshift-data =
    buildTypesAiobotocorePackage "redshift-data" "2.25.2"
      "sha256-cM+3HLOFfWrEawh6po1zebYx/iw5FjYUvB+y0X1VeAM=";

  types-aiobotocore-redshift-serverless =
    buildTypesAiobotocorePackage "redshift-serverless" "2.25.2"
      "sha256-xZsnMH6mKYIi17QlOqHRUbntwh6rLyZlvigN2M13qt8=";

  types-aiobotocore-rekognition =
    buildTypesAiobotocorePackage "rekognition" "2.25.2"
      "sha256-MPiEtnazV91O74r0iQ285THqbiLqoAWxb2OF1XXK2Ew=";

  types-aiobotocore-resiliencehub =
    buildTypesAiobotocorePackage "resiliencehub" "2.25.2"
      "sha256-MemIUV9PmsV+1hmRJrzry5cWyZ+Sol8fwjpIT129em8=";

  types-aiobotocore-resource-explorer-2 =
    buildTypesAiobotocorePackage "resource-explorer-2" "2.25.2"
      "sha256-P1hKQiKYdj2ENId6Xd17v2TAOH0cYJZs0M8l93yAdjA=";

  types-aiobotocore-resource-groups =
    buildTypesAiobotocorePackage "resource-groups" "2.25.2"
      "sha256-mehT32Cu11oq9/nAlrbBWG9Bk8Led/CXCm8Am7VoG8c=";

  types-aiobotocore-resourcegroupstaggingapi =
    buildTypesAiobotocorePackage "resourcegroupstaggingapi" "2.25.2"
      "sha256-aY46IDVal+xGidm+Ov4GyY+uz15nT8BWYR3dQu7uri4=";

  types-aiobotocore-robomaker =
    buildTypesAiobotocorePackage "robomaker" "2.24.2"
      "sha256-EczunxMisSO9t2iYzXuzTeFiNalu2EyDRIOE7TW5fOg=";

  types-aiobotocore-rolesanywhere =
    buildTypesAiobotocorePackage "rolesanywhere" "2.25.2"
      "sha256-oYy2x4IOVeM3RaphZGI/JcOnZ2+SSOinB7eOC14CsX0=";

  types-aiobotocore-route53 =
    buildTypesAiobotocorePackage "route53" "2.25.2"
      "sha256-ikAu/EgY3+nIli8hQ80hq806vZwfCSQpt4jS7EhE9Zw=";

  types-aiobotocore-route53-recovery-cluster =
    buildTypesAiobotocorePackage "route53-recovery-cluster" "2.25.2"
      "sha256-GUzOVHDOGQviIujhWIVC6y/gRawsqK4DRMhuam0N1/M=";

  types-aiobotocore-route53-recovery-control-config =
    buildTypesAiobotocorePackage "route53-recovery-control-config" "2.25.2"
      "sha256-Onq9TVrQ5J4EgkMfkajHnw7Gp4TSEbhyOFEnCODLwKw=";

  types-aiobotocore-route53-recovery-readiness =
    buildTypesAiobotocorePackage "route53-recovery-readiness" "2.25.2"
      "sha256-c/qst7MAAyUIokZoh84dKs0i+WCoSQA6xh99YQvXZm4=";

  types-aiobotocore-route53domains =
    buildTypesAiobotocorePackage "route53domains" "2.25.2"
      "sha256-MwG+PJGNx/NcZJDL8c3DCoE2FBseyTTFHdShEbbvevU=";

  types-aiobotocore-route53resolver =
    buildTypesAiobotocorePackage "route53resolver" "2.25.2"
      "sha256-SasLn3MEK1/MAHBVctJORkMTrZRsdEWjvemliiG1wb4=";

  types-aiobotocore-rum =
    buildTypesAiobotocorePackage "rum" "2.25.2"
      "sha256-WtE80P8/53O2uySzTADOue/V7GAbAEy6xvlC/cRhwIE=";

  types-aiobotocore-s3 =
    buildTypesAiobotocorePackage "s3" "2.25.2"
      "sha256-Z4qkJUka8ZvW0BHVns27t65+lYAO/dz0/VWatyyU4ZQ=";

  types-aiobotocore-s3control =
    buildTypesAiobotocorePackage "s3control" "2.25.2"
      "sha256-Z5NdbrneSn+wvSV+cqEmhR+XJj75T5M9BM6T2jG8Fgg=";

  types-aiobotocore-s3outposts =
    buildTypesAiobotocorePackage "s3outposts" "2.25.2"
      "sha256-oUsMwIvMhGH+aD7sWvXrNth6gAc9DRHI09cU+OrQTmg=";

  types-aiobotocore-sagemaker =
    buildTypesAiobotocorePackage "sagemaker" "2.25.2"
      "sha256-m4js7ovT8ZA5aWixnabpG/MXwo3S+eWp5nW+u/t7MC0=";

  types-aiobotocore-sagemaker-a2i-runtime =
    buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "2.25.2"
      "sha256-7Qr0XBjlFzkmVB7C7WOlYWKbwWcJEi8vy2RK+qn7nE0=";

  types-aiobotocore-sagemaker-edge =
    buildTypesAiobotocorePackage "sagemaker-edge" "2.25.2"
      "sha256-A4IS8g8NFTFbJSZphqo6a06E8eJD1BwdKbw7rIiu49o=";

  types-aiobotocore-sagemaker-featurestore-runtime =
    buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "2.25.2"
      "sha256-Nfe7eC1so9KdS04bDamIWhNigjbgq+Thz2RG/EMlhwI=";

  types-aiobotocore-sagemaker-geospatial =
    buildTypesAiobotocorePackage "sagemaker-geospatial" "2.25.2"
      "sha256-fwo5NiBw7em2fbh3yVjHaTGRpjqAlY5iMQsty4HQDsg=";

  types-aiobotocore-sagemaker-metrics =
    buildTypesAiobotocorePackage "sagemaker-metrics" "2.25.2"
      "sha256-M0Jwr2wDThnN/svLt1gI5TznP1O1XnBOHb9NDzw7OyE=";

  types-aiobotocore-sagemaker-runtime =
    buildTypesAiobotocorePackage "sagemaker-runtime" "2.25.2"
      "sha256-boH4ui89Xbftyk7e+udTMuReuYijeRoQd346S4pstzk=";

  types-aiobotocore-savingsplans =
    buildTypesAiobotocorePackage "savingsplans" "2.25.2"
      "sha256-X0/zJsYNPHqTLwgCWMNnuWluFbzNudOfwLZC/8/3418=";

  types-aiobotocore-scheduler =
    buildTypesAiobotocorePackage "scheduler" "2.25.2"
      "sha256-4NkSUfG7f9xbiP/qejBrcM4/pVKs1nbTsEC3Ai9K1u4=";

  types-aiobotocore-schemas =
    buildTypesAiobotocorePackage "schemas" "2.25.2"
      "sha256-LXIojO67yX5N7spXUUit67VnGXR7HGJ9mnAD38cyR1M=";

  types-aiobotocore-sdb =
    buildTypesAiobotocorePackage "sdb" "2.25.2"
      "sha256-KLojew5L5OZJORFqnX+iOYc+NuSacKIhIuLNaO53Uhg=";

  types-aiobotocore-secretsmanager =
    buildTypesAiobotocorePackage "secretsmanager" "2.25.2"
      "sha256-QDsOrUlDEXfIbxa1Ij5t3R/PRUVzIgZHsk4Fnu6t9vI=";

  types-aiobotocore-securityhub =
    buildTypesAiobotocorePackage "securityhub" "2.25.2"
      "sha256-X3m2pYT//vWq1d+8PRka2eDv4l3CiLH2ZuVLGM98V+8=";

  types-aiobotocore-securitylake =
    buildTypesAiobotocorePackage "securitylake" "2.25.2"
      "sha256-E6/FccJAlnTHCZjKG+JucSMHWEorpdYP+sKXwLKpyrk=";

  types-aiobotocore-serverlessrepo =
    buildTypesAiobotocorePackage "serverlessrepo" "2.25.2"
      "sha256-g6l/6KFa73MYE0PSvl6PEdfHuE3ij0TNPqx5+dK1udg=";

  types-aiobotocore-service-quotas =
    buildTypesAiobotocorePackage "service-quotas" "2.25.2"
      "sha256-NjfZsVuaB5zI3/5EuM15D7mM6lHVRTz6KrMI2B+nbeU=";

  types-aiobotocore-servicecatalog =
    buildTypesAiobotocorePackage "servicecatalog" "2.25.2"
      "sha256-uzQaPQZFCzv6VUDJxHdGa948VJCxn2NznHVpEohXzx0=";

  types-aiobotocore-servicecatalog-appregistry =
    buildTypesAiobotocorePackage "servicecatalog-appregistry" "2.25.2"
      "sha256-plc4BQ4qAGknWErN2ebG7Qa4yfIZ53VdWXGLWGj3FYk=";

  types-aiobotocore-servicediscovery =
    buildTypesAiobotocorePackage "servicediscovery" "2.25.2"
      "sha256-boUZCGEBYg8su3BhK8MaBywQhQy5vShB7qlvXhA+W8Y=";

  types-aiobotocore-ses =
    buildTypesAiobotocorePackage "ses" "2.25.2"
      "sha256-fHv1A31/W1iyxflLNgdJVISL4fXOu94w+DnkWmEWHbk=";

  types-aiobotocore-sesv2 =
    buildTypesAiobotocorePackage "sesv2" "2.25.2"
      "sha256-xHqQJ/bLmwGjYJUvLS5ReaG9RB4IrWI7LDMR6jeYqyY=";

  types-aiobotocore-shield =
    buildTypesAiobotocorePackage "shield" "2.25.2"
      "sha256-AR/Ou5K0uL/056VW/fSxtyxQCEmI0aRmAg0aKYCxAEc=";

  types-aiobotocore-signer =
    buildTypesAiobotocorePackage "signer" "2.25.2"
      "sha256-UwuSnhTOygGyR2SOoUjbNJBOlA+kXVK5Z/5482kIsRU=";

  types-aiobotocore-simspaceweaver =
    buildTypesAiobotocorePackage "simspaceweaver" "2.25.2"
      "sha256-pirV04Q1tTL/SsA4TbwmCXXYWTfFQt+cADu0inYIlOk=";

  types-aiobotocore-sms =
    buildTypesAiobotocorePackage "sms" "2.24.2"
      "sha256-aZuGmKtxe3ERjMUZ5jNiZUaVUqDaCHKQQ6wMTsGkcVs=";

  types-aiobotocore-sms-voice =
    buildTypesAiobotocorePackage "sms-voice" "2.22.0"
      "sha256-nlg8QppdMa4MMLUQZXcxnypzv5II9PqEtuVc09UmjKU=";

  types-aiobotocore-snow-device-management =
    buildTypesAiobotocorePackage "snow-device-management" "2.25.2"
      "sha256-1wLvRk7FyWumejawyrHkc2RKipe/xyRYgU3fdX9HADM=";

  types-aiobotocore-snowball =
    buildTypesAiobotocorePackage "snowball" "2.25.2"
      "sha256-V3aFIrmtrK0zILT2/7MwDXBdKhAanWSaOkGUG8EzeXE=";

  types-aiobotocore-sns =
    buildTypesAiobotocorePackage "sns" "2.25.2"
      "sha256-6LQYAP8vd11/aO4HlXKZ79x13CR5Ww3leaf5T+iTgts=";

  types-aiobotocore-sqs =
    buildTypesAiobotocorePackage "sqs" "2.25.2"
      "sha256-YLOPTt5tg8xr2C2ysHIamDzVAQ8c+njtqo5bOAkXsHc=";

  types-aiobotocore-ssm =
    buildTypesAiobotocorePackage "ssm" "2.25.2"
      "sha256-X6oz36PvyB9q8GZsS4MjPfgYcyMN6l8xgjOUT/9zh68=";

  types-aiobotocore-ssm-contacts =
    buildTypesAiobotocorePackage "ssm-contacts" "2.25.2"
      "sha256-5zWlITNHtAHHIpjtxYtPib7KVxk/Jt/Dd9iJtCw3dLM=";

  types-aiobotocore-ssm-incidents =
    buildTypesAiobotocorePackage "ssm-incidents" "2.25.2"
      "sha256-2iNhPY2eaU+AO5lo9clycd0gDQjDAs1wZf8QyPcMS+s=";

  types-aiobotocore-ssm-sap =
    buildTypesAiobotocorePackage "ssm-sap" "2.25.2"
      "sha256-307LaZUb5nozKZpGeWXQa7QzhCFCqtHvZUqpRGRMk1g=";

  types-aiobotocore-sso =
    buildTypesAiobotocorePackage "sso" "2.25.2"
      "sha256-QW2nIHxE+Ln//tAza0l4eJLhD+hOZkS3yUtAkNI0jC8=";

  types-aiobotocore-sso-admin =
    buildTypesAiobotocorePackage "sso-admin" "2.25.2"
      "sha256-5zg/JlCVsW9nS9SAgXut2efHftfHLMjX82hPuJy2ksA=";

  types-aiobotocore-sso-oidc =
    buildTypesAiobotocorePackage "sso-oidc" "2.25.2"
      "sha256-wxn2CFcKeTHQ7krf0ma+GVtj74Kkj/p6jUE5OLcRlF0=";

  types-aiobotocore-stepfunctions =
    buildTypesAiobotocorePackage "stepfunctions" "2.25.2"
      "sha256-MbW+UDqsRKf70ir45sptYlHR3KERTL85XhYWiejki/o=";

  types-aiobotocore-storagegateway =
    buildTypesAiobotocorePackage "storagegateway" "2.25.2"
      "sha256-E7L7+KuSakHszktTGwMHKupMfu/jNJkNgmWjLVSHpAc=";

  types-aiobotocore-sts =
    buildTypesAiobotocorePackage "sts" "2.25.2"
      "sha256-E0InEkPQP9jUoeq1ZtkTf3Dscju2rWE2acdBUqw6BCc=";

  types-aiobotocore-support =
    buildTypesAiobotocorePackage "support" "2.25.2"
      "sha256-hDpBS5hZdlS7+3gQEyZxfZEq3lKUI55KIDD8IwaCXBY=";

  types-aiobotocore-support-app =
    buildTypesAiobotocorePackage "support-app" "2.25.2"
      "sha256-5yQd+l6oIaUO9GRNysKXBu3XViKofbUYJey9eO/5rmk=";

  types-aiobotocore-swf =
    buildTypesAiobotocorePackage "swf" "2.25.2"
      "sha256-VLYDLm6OC2AuvKZSdDdWnYUqeMhOvzH1X8nz7T8gXi4=";

  types-aiobotocore-synthetics =
    buildTypesAiobotocorePackage "synthetics" "2.25.2"
      "sha256-PDnh4RIE2M9IGnIObZpyfwitCbwwDMdO1Cd2I96F19E=";

  types-aiobotocore-textract =
    buildTypesAiobotocorePackage "textract" "2.25.2"
      "sha256-uKz1pPOWo474dOSuvegbDYEmvdFP0NAdNPJInjbp4XQ=";

  types-aiobotocore-timestream-query =
    buildTypesAiobotocorePackage "timestream-query" "2.25.2"
      "sha256-rCyZ7XTSufUWNILASHToO9hX5lqoG11GNx55rKSbEbY=";

  types-aiobotocore-timestream-write =
    buildTypesAiobotocorePackage "timestream-write" "2.25.2"
      "sha256-tMnAN2/aFHXDWlG+6xfB9l3x0NZYxx1OFCdYuSAg3sg=";

  types-aiobotocore-tnb =
    buildTypesAiobotocorePackage "tnb" "2.25.2"
      "sha256-nLVbqJ/EmnIjNDHEiNvvt9ERgFgzN1h3StKoJRxhDWs=";

  types-aiobotocore-transcribe =
    buildTypesAiobotocorePackage "transcribe" "2.25.2"
      "sha256-QLd7BD5aQISweJwtpkZqvXnWrZFI6mtlsH2Cqy2m0qA=";

  types-aiobotocore-transfer =
    buildTypesAiobotocorePackage "transfer" "2.25.2"
      "sha256-xV3U/3sm95AvdaoB7Gbt4TBZmaB/3Vr5DPWDgVBSzJY=";

  types-aiobotocore-translate =
    buildTypesAiobotocorePackage "translate" "2.25.2"
      "sha256-OnwTrcl5IivstCBPxL5L1FHzOHkgoP4ckt78ROjI76o=";

  types-aiobotocore-verifiedpermissions =
    buildTypesAiobotocorePackage "verifiedpermissions" "2.25.2"
      "sha256-hyHQ2pKSwsfiATWjG0A+Th4h7S1t4hpZV2XMpxVuo2E=";

  types-aiobotocore-voice-id =
    buildTypesAiobotocorePackage "voice-id" "2.25.2"
      "sha256-HBVCiam1snON2/ofnBZeLgFwtXksftt/wU97VO8selU=";

  types-aiobotocore-vpc-lattice =
    buildTypesAiobotocorePackage "vpc-lattice" "2.25.2"
      "sha256-mesor2Mn8DCTrsS1jqJUzvQryqzDfay6CsuXwdZI46o=";

  types-aiobotocore-waf =
    buildTypesAiobotocorePackage "waf" "2.25.2"
      "sha256-y0BWcRKW3SE2DdsvMS6oe4jz6h1ksBp4BwbQ0jB6M6g=";

  types-aiobotocore-waf-regional =
    buildTypesAiobotocorePackage "waf-regional" "2.25.2"
      "sha256-q461MckctNY7+vfJnbWSTJaG4xsG+lXieujmoScEIZ0=";

  types-aiobotocore-wafv2 =
    buildTypesAiobotocorePackage "wafv2" "2.25.2"
      "sha256-dJihdjOMtnnrihFTA5AlB3jJ5auiwhr+GjOwFTWu5ow=";

  types-aiobotocore-wellarchitected =
    buildTypesAiobotocorePackage "wellarchitected" "2.25.2"
      "sha256-oCFtzcmkBb4DXzp1aNvbJHSDmVYzreK/9c4bD36vBpU=";

  types-aiobotocore-wisdom =
    buildTypesAiobotocorePackage "wisdom" "2.25.2"
      "sha256-WpQwt6W1eFs18LiDdiCu23caJdz773IDlksFf0eqnoo=";

  types-aiobotocore-workdocs =
    buildTypesAiobotocorePackage "workdocs" "2.25.2"
      "sha256-9omeJus64ob2dl5+XlC1NdpJUmFPypi7Ykut30rTWxo=";

  types-aiobotocore-worklink =
    buildTypesAiobotocorePackage "worklink" "2.15.1"
      "sha256-VvuxiybvGaehPqyVUYGO1bbVSQ0OYgk6LbzgoKLHF2c=";

  types-aiobotocore-workmail =
    buildTypesAiobotocorePackage "workmail" "2.25.2"
      "sha256-N78CJhAyGLeimpBaMALmO/L+WD10CL+6Y9DfY5zKvQw=";

  types-aiobotocore-workmailmessageflow =
    buildTypesAiobotocorePackage "workmailmessageflow" "2.25.2"
      "sha256-5mnYGmH4f35KvnVLBM20dbFSKavvlT+frDD80R6QLFA=";

  types-aiobotocore-workspaces =
    buildTypesAiobotocorePackage "workspaces" "2.25.2"
      "sha256-hh35xtsO8A2r/neAaNkfTJTfH1Tmoi3ghPLlgAanMBQ=";

  types-aiobotocore-workspaces-web =
    buildTypesAiobotocorePackage "workspaces-web" "2.25.2"
      "sha256-CiyBtyvaljno38C0A9kh6nNqZTF+t2htfEHvjg2zn9k=";

  types-aiobotocore-xray =
    buildTypesAiobotocorePackage "xray" "2.25.2"
      "sha256-96oY3VaT2gc7FdQ3GOOSVNXEm1LQLhM8ROFxetvRo3s=";
}
