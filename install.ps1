 <#

.SYNOPSIS
Custom VM Extension script for Prisma Cloud Compute Defender installation on Windows hosts.

.DESCRIPTION
Custom VM Extension script for Prisma Cloud Compute Defender installation on Windows hosts.

.EXAMPLE
TODO

.PARAMETER bearer
Mandatory parameter which contains the bearer/api token.

.PARAMETER url
Mandatory parameter which contains the url where the console is located.

.PARAMETER tenant
Mandatory parameter which contains the url where the console is located.

#>

# Version 0.1 (2021-08-12)
# This version is modified for public publication. 

param ( [parameter(Mandatory = $true)][string]$bearer,
        [parameter(Mandatory = $true)][string]$url,
        [parameter(Mandatory = $true)][string]$tenant)

$parameters = @{ 
    Uri = "https://$url/$tenant/api/v1/scripts/defender.ps1"; 
    Method = "Post"; 
    Headers = @{
        "authorization" = "Bearer $bearer" }; 
    OutFile = "defender.ps1"; ; 
}; 

if ($PSEdition -eq 'Desktop') 
    { add-type " using System.Net; using System.Security.Cryptography.X509Certificates; public class TrustAllCertsPolicy : ICertificatePolicy{ public bool CheckValidationResult(ServicePoint srvPoint, X509Certificate certificate, WebRequest request, int certificateProblem) { return true; } } "; 
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy; } 
else 
    { $parameters.SkipCertificateCheck = $true; } 
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; 
    
Invoke-WebRequest @parameters; .\defender.ps1 -type serverWindows -consoleCN $url -install 
