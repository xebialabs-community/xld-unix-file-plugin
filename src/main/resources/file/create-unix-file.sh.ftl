<#--

    THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS
    FOR A PARTICULAR PURPOSE. THIS CODE AND INFORMATION ARE NOT SUPPORTED BY XEBIALABS.

-->
<#--
THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS
FOR A PARTICULAR PURPOSE. THIS CODE AND INFORMATION ARE NOT SUPPORTED BY XEBIALABS.
-->
#!/bin/sh

if [ ! -d "${deployed.targetPath}" ]; then
  echo Creating target path '${deployed.targetPath}'<#if deployed.createTargetPath> and parents</#if>
  mkdir <#if deployed.createTargetPath>-p </#if>"${deployed.targetPath}"
  res=$?
  if [ $res != 0 ] ; then
    exit $res
  fi
else
  echo Target path '${deployed.targetPath}' already exists
fi

<#if deployed.targetFileName?has_content>
TARGET_FILE_NAME=${deployed.targetFileName}
<#else>
TARGET_FILE_NAME=${deployed.name}
</#if>

TARGET_FILE=${deployed.targetPath}/$TARGET_FILE_NAME
echo Creating "$TARGET_FILE"
cp "${deployed.file}" "$TARGET_FILE"
res=$?
if [ $res != 0 ] ; then
  exit $res
fi

<#if deployed.permissions?has_content>
echo Setting file permissions on "$TARGET_FILE" to ${deployed.permissions}
chmod ${deployed.permissions} "$TARGET_FILE"
res=$?
if [ $res != 0 ] ; then
  exit $res
fi
</#if>
