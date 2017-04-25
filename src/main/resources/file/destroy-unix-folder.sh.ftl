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
  echo WARN: '${deployed.targetPath}' not found. Nothing to do.
  exit
fi
<#if deployed.targetPathShared>
echo Deleting from shared path '${deployed.targetPath}'
for ORIGINAL_FILE in `find . -type f`; do
  FILE_TO_DELETE=${deployed.targetPath}/$ORIGINAL_FILE
  echo ">> Deleting file $FILE_TO_DELETE"
  rm -rf "$FILE_TO_DELETE"
done
for ORIGINAL_FILE in `find . -type d | grep "^\.."`; do
  FILE_TO_DELETE=${deployed.targetPath}/$ORIGINAL_FILE
  echo ">> Deleting directory $FILE_TO_DELETE"
  rmdir "$FILE_TO_DELETE"
  if [ "$?" = "1" ];
  then
     echo "$FILE_TO_DELETE is not empty"
  fi
done
<#else/>
echo Deleting folder '${deployed.targetPath}'
rm -rf "${deployed.targetPath}"
</#if>
res=$?
if [ $res != 0 ] ; then
  exit $res
fi
