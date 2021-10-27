<#--

Copyright 2021 DIGITAL.AI
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

-->
#!${previousDeployed.shell}

<#if previousDeployed.file.path??>
# do not remove - this actually triggers the upload
cd "${previousDeployed.file.path}"
</#if>

if [ ! -d "${previousDeployed.targetPath}" ]; then
  echo WARN: '${previousDeployed.targetPath}' not found. Nothing to do.
  exit
fi
<#if previousDeployed.targetPathShared>
echo Deleting from shared path '${previousDeployed.targetPath}'
for ORIGINAL_FILE in `find . -type f`; do
  FILE_TO_DELETE=${previousDeployed.targetPath}/$ORIGINAL_FILE
  echo ">> Deleting file $FILE_TO_DELETE"
  rm -rf "$FILE_TO_DELETE"
done
for ORIGINAL_FILE in `find . -type d | grep "^\.."`; do
  FILE_TO_DELETE=${previousDeployed.targetPath}/$ORIGINAL_FILE
  echo ">> Deleting directory $FILE_TO_DELETE"
  rmdir "$FILE_TO_DELETE"
  if [ "$?" = "1" ];
  then
     echo "$FILE_TO_DELETE is not empty"
  fi
done
<#else/>
echo Deleting folder '${previousDeployed.targetPath}'
rm -rf "${previousDeployed.targetPath}"
</#if>
res=$?
if [ $res != 0 ] ; then
  exit $res
fi
