param($installPath, $toolsPath, $package, $project)

Function prependResourceDictionaryReference($xml, $parent, $location)
{
    #Add for Colours resource
    $resourceAttr = $xml.CreateAttribute("Source")
    $resourceAttr.Value = $location 
    $resourceDict = $xml.CreateElement("ResourceDictionary", $xml.Application.NamespaceUri)
    $resourceDict.Attributes.Append($resourceAttr)
    $parent.PrependChild($resourceDict)
    $parent.PrependChild($xml.CreateWhitespace("
                "))
}

Write-Host "Running install.ps1 for Package $($package.Id)"

# find the App.xaml file 
$config = $project.ProjectItems | where {$_.Name -eq "App.xaml"}
 
# find its path on the file system 
$localPath = $config.Properties | where {$_.Name -eq "LocalPath"}
 

 # get RootNamespace value
 $rootnamespace = $project.Properties.Item("RootNamespace").Value

 # get localNamespaceUri from default root namespace
 $localNameSpace = "clr-namespace:" + $rootnamespace

# load App.xaml as XML 
$xml = New-Object xml
$xml.PreserveWhitespace = $true
$xml.Load($localPath.Value)

if($xml.Application.HasAttribute("StartupUri"))
{
  Write-Host "Removing StartupUri Attribute"
  $xml.Application.RemoveAttribute("StartupUri")
}

$appResources = $xml.Application.ChildNodes | where { $_.Name -eq "Application.Resources"}
if($appResources -eq $null)
{
  $appResources = $xml.CreateElement("Application.Resources", $xml.Application.NamespaceUri)
  $xml.Application.PrependChild($xml.CreateWhitespace("
"))
  $xml.Application.PrependChild($appResources)
  $xml.Application.PrependChild($xml.CreateWhitespace("
    "))
}

$nonwhitespaces = $appResources.ChildNodes | where {$_.NodeType -ne [System.Xml.XmlNodeType]::Whitespace }
if($nonwhitespaces -eq $null)
{
  $appResources.RemoveAll()
}

$appRDict = $appResources.ChildNodes | where { $_.Name -eq "ResourceDictionary"}
if($appRDict -eq $null)
{
  $appRDict = $xml.CreateElement("ResourceDictionary", $xml.Application.NamespaceUri)
  $appRDict.PrependChild($xml.CreateWhitespace("
        "))
  $nonwhitespaceResources = $appResources.ChildNodes | where {$_.NodeType -ne [System.Xml.XmlNodeType]::Whitespace }
  if($nonwhitespaceResources -ne $null)
  {
    # insert existing children into this element, if any
    $nonwhitespaceResources | foreach { $appRDict.PrependChild($_) }
  }
  $appResources.RemoveAll()
  
  $appResources.PrependChild($xml.CreateWhitespace("
    "))
  $appResources.PrependChild($appRDict)
  $appResources.PrependChild($xml.CreateWhitespace("
        "))
}

$mergedDicts = $appRDict.ChildNodes | where { $_.Name -eq "ResourceDictionary.MergedDictionaries"}
if($mergedDicts -eq $null)
{
  $mergedDicts = $xml.CreateElement("ResourceDictionary.MergedDictionaries", $xml.Application.NamespaceUri)
  $mergedDicts.PrependChild($xml.CreateWhitespace("
            "))
  $appRDict.PrependChild($xml.CreateWhitespace("
        "))
  $appRDict.PrependChild($mergedDicts)
  $appRDict.PrependChild($xml.CreateWhitespace("
            "))
}

$localAttr = $xml.CreateAttribute("xmlns:local")
$localAttr.Value = $localNameSpace
$xml.Application.Attributes.Append($localAttr)

#Add for BaseLight Accents resource
prependResourceDictionaryReference $xml $mergedDicts "pack://application:,,,/MahApps.Metro;component/Styles/Accents/BaseLight.xaml"

#Add for Blue Accents resource
prependResourceDictionaryReference $xml $mergedDicts "pack://application:,,,/MahApps.Metro;component/Styles/Accents/Blue.xaml"

#Add for Controls resource
prependResourceDictionaryReference $xml $mergedDicts "pack://application:,,,/MahApps.Metro;component/Styles/Controls.xaml"

#Add for Fonts resource
prependResourceDictionaryReference $xml $mergedDicts "pack://application:,,,/MahApps.Metro;component/Styles/Fonts.xaml" 
#$fontsAttr = $xml.CreateAttribute("Source")
#$fontsAttr.Value = "pack://application:,,,/MahApps.Metro;component/Styles/Fonts.xaml" 
#$fontsResDict = $xml.CreateElement("ResourceDictionary", $xml.Application.NamespaceUri)
#$fontsResDict.Attributes.Append($fontsAttr)
#$mergedDicts.PrependChild($xml.CreateWhitespace("
#                "))
#$mergedDicts.PrependChild($fontsResDict)

#Add for Colours resource
prependResourceDictionaryReference $xml $mergedDicts "pack://application:,,,/MahApps.Metro;component/Styles/Colours.xaml"
#$coloursAttr = $xml.CreateAttribute("Source")
#$coloursAttr.Value = "pack://application:,,,/MahApps.Metro;component/Styles/Colours.xaml" 
#$coloursResDict = $xml.CreateElement("ResourceDictionary", $xml.Application.NamespaceUri)
#$coloursResDict.Attributes.Append($coloursAttr)
#$mergedDicts.PrependChild($xml.CreateWhitespace("
#                "))
#$mergedDicts.PrependChild($coloursResDict)

#Add ResourceDictionary for Bootstrapper
$bootDict = $xml.CreateElement("ResourceDictionary", $xml.Application.NamespaceUri)
$bootstrapper = $xml.CreateElement("local", "AppBootstrapper", $localNameSpace)
$bootKeyAttr = $xml.CreateAttribute("x", "Key", $xml.Application.Attributes.GetNamedItem("xmlns:x").Value)
$bootKeyAttr.Value = "bootstrapper"
$bootstrapper.Attributes.Append($bootKeyAttr)
$bootDict.AppendChild($xml.CreateWhitespace("
                    "))
$bootDict.AppendChild($bootstrapper)
$bootDict.AppendChild($xml.CreateWhitespace("
                "))
$mergedDicts.PrependChild($bootDict)
$mergedDicts.PrependChild($xml.CreateWhitespace("
                "))

# save the App.xaml file 
$xml.Save($localPath.Value)
