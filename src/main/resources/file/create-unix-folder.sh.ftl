<#--
THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS
FOR A PARTICULAR PURPOSE. THIS CODE AND INFORMATION ARE NOT SUPPORTED BY XEBIALABS.
-->
#!/bin/sh

<#if deployed.file??>
# do not remove - this actually triggers the upload
cd "${deployed.file}"
</#if>

if [ ! -d "${deployed.targetPath}" ]; then
  echo Creating target path '${deployed.targetPath}'<#if deployed.createTargetPath> and parents</#if>
  mkdir <#if deployed.createTargetPath>-p </#if>"${deployed.targetPath}"
else
  echo Target path '${deployed.targetPath}' already exists
fi

echo Creating folder '${deployed.targetPath}'
cp -r . "${deployed.targetPath}"
res=$?
if [ $res != 0 ] ; then
  exit $res
fi

<#if deployed.permissions?has_content>
  <#if deployed.targetPathShared>
  for ORIGINAL_FILE in `find . `; do
    FILE_TO_CHMOD=${deployed.targetPath}/$ORIGINAL_FILE
    echo Setting file permissions on $FILE_TO_CHMOD to ${deployed.permissions}
    chmod -R ${deployed.permissions} "$FILE_TO_CHMOD"
  done
  <#else/>
  echo Setting file permissions on '${deployed.targetPath}' to ${deployed.permissions}
  chmod -R ${deployed.permissions} "${deployed.targetPath}"
  </#if>
res=$?
if [ $res != 0 ] ; then
  exit $res
fi
</#if>
