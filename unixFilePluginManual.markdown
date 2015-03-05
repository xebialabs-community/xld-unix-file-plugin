## Preface

This document describes the functionality provided by the Unix File Plugin.

Refer to the [XL Deploy Reference Manual](https://docs.xebialabs.com/xl-deploy/4.5.x/referencemanual.html) for background information on XL Deploy and deployment concepts.

## Overview

In many cases, an application depends on external resources for its configuration. The application accesses these resources
from a predefined location or using a predefined mechanism.

In the simplest of forms, a resource can be described as a file, an archive (`ZIP`), or a folder (collection of files). The Unix File Plugin enables the definition of such resources in a deployment package and subsequently managing them on a target host.

The resources can contain placeholders that the plugin will replace when targeting to the specific host, thus allowing resources to be defined independent of their environment.

### Features

Deploy, upgrade, and undeploy a file based resource on a [Host](#overthere.Host).

* [UnixFile](#file.UnixFile)
* [UnixFolder](#file.UnixFolder)

## Requirements

This plugin requires:

* **XL Deploy**: version 4.0+

## Usage in Deployment Packages

Please refer to  [Packaging Manual](https://docs.xebialabs.com/xl-deploy/4.5.x/packagingmanual.html) for more details about the DAR packaging format.

Sample DAR manifest entries defining a file, folder, and archive resource:

    <udm.DeploymentPackage version="1.0" application="UnixFilePluginSample">
        <file.UnixFile name="sampleFile" file="sampleFile.txt"/>
        <file.UnixFolder name="sampleFolder" file="sampleFolder" />
    </udm.DeploymentPackage>

## Using the deployables and deployeds

### Deployable vs. Container Table

The following table describes which deployable / container combinations are possible.
Note that the CIs can only be targeted to containers derived from [Host](#overthere.Host).

<table class="deployed-matrix nobreak">
<tr>
    <th>Deployables</th> <th>Containers</th> <th>Generated Deployed</th>
</tr>
<tr>
	<td>file.UnixFile</td> <td>overthere.Host</td> <td>file.CopiedUnixFile</td>
</tr>
<tr>
	<td>file.UnixFolder</td> <td>overthere.Host</td> <td>file.CopiedUnixFolder</td>
</tr>
</table>

### Deployed Actions Table

The following table describes the effect a deployed has on its container.

<table class="deployed-matrix nobreak">
<tr>
	<th>Deployed</th><th align="center">Create</th> <th align="center">Destroy</th> <th align="center">Modify</th>
</tr>
<tr>
	<td>file.CopiedUnixFile</td>
	<td>
	    <ul>
	        <li>Create target path on host, if needed</li>
	        <li>Copy file to target path on host</li>
	        <li>Set Unix file permissions</li>
	    </ul>
	</td>
	<td>
	    <ul>
	        <li>Delete file from host</li>
	    </ul>
	</td>
	<td>
	    <ul>
	        <li>Delete old file from host</li>
	        <li>Copy modified file to target path on host</li>
	        <li>Set Unix file permissions</li>
	    </ul>
	</td>
</tr>
<tr>
	<td>file.CopiedUnixFolder</td>
	<td>
	    <ul>
	        <li>Create target folder on host, if needed</li>
	        <li>Copy folder content to target folder on host</li>
	        <li>Set Unix file permissions</li>
	    </ul>
	</td>
	<td>
	    <ul>
	        <li>Delete folder content from host</li>
	        <li>If folder is not a shared folder, the folder itself is deleted from host</li>
	    </ul>
	</td>
	<td>
	    <ul>
	        <li>Perform actions as described by <em>Destroy</em> for old folder</li>
	        <li>Perform actions as described by <em>Create</em> for modified folder</li>
	        <li>Set Unix file permissions</li>
	    </ul>
	</td>
</tr>
</table>
