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
#!${deployed.shell}

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

for DIR_NAME in `find . -type d`;do
    if [ ! -e "${deployed.targetPath}/${r"${DIR_NAME}"}" ];then
         echo "Make subdirectory ${r"${DIR_NAME}"}"
         mkdir -p ${deployed.targetPath}/${r"${DIR_NAME}"}
    fi
done
for FILE_NAME in `find . -type f`; do
    FILE_NAME=`echo $FILE_NAME | sed "s/^\.\///g"`
    if [ -e "${deployed.targetPath}/${r"${FILE_NAME}"}" ];then
         SCKSUM=`cat $FILE_NAME | cksum`
         DCKSUM=`cat ${deployed.targetPath}/${r"${FILE_NAME}"} | cksum`
         if [ "$DCKSUM" != "$SCKSUM" ]; then
            echo "Copy $FILE_NAME to ${deployed.targetPath} ( $SCKSUM / $DCKSUM )"
            echo ${r"${FILE_NAME}"} | cpio -pdmB ${deployed.targetPath} 
         fi
    else
         echo "Copy $FILE_NAME to ${deployed.targetPath}"
         echo ${r"${FILE_NAME}"} | cpio -pdmB ${deployed.targetPath}
    fi
done
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
