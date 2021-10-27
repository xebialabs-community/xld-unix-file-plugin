<#--

Copyright 2021 DIGITAL.AI
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

-->
#!${deployed.shell}

<#if deployed.file.path??>
# do not remove - this actually triggers the upload
cd "${deployed.file.path}"
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
  perms=`expr ${deployed.permissions} + 111`
  echo Setting file permissions on '${deployed.targetPath}' to $perms
  chmod $perms "${deployed.targetPath}"
  </#if>
  for ORIGINAL_FILE in `find . -type d`; do
    perms=`expr ${deployed.permissions} + 111`
    FILE_TO_CHMOD=${deployed.targetPath}/$ORIGINAL_FILE
    echo Setting file permissions on $FILE_TO_CHMOD to $perms
    chmod $perms "$FILE_TO_CHMOD"
  done
  for ORIGINAL_FILE in `find . -type f`; do
    FILE_TO_CHMOD=${deployed.targetPath}/$ORIGINAL_FILE
    echo Setting file permissions on $FILE_TO_CHMOD to ${deployed.permissions}
    chmod ${deployed.permissions} "$FILE_TO_CHMOD"
  done
res=$?
if [ $res != 0 ] ; then
  exit $res
fi
</#if>
