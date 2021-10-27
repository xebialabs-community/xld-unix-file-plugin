<#--

Copyright 2021 DIGITAL.AI
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

-->
#!${deployed.shell}

if [ ! -d "${deployed.targetPath}" ]; then
  echo Creating target path '${deployed.targetPath}'<#if deployed.createTargetPath> and parents</#if>
  mkdir <#if deployed.createTargetPath> -p </#if>"${deployed.targetPath}"
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
echo "Creating $TARGET_FILE"
echo "Source file ${deployed.file.path}"
cp "${deployed.file.path}" "$TARGET_FILE"
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
