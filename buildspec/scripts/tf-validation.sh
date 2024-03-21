terraform init
terraform validate
tfValidateOutput=$?

terraform fmt -recursive
tfFormatOutput=$?

echo "Validation Summary:"
echo "Validate Output: ${tfValidateOutput}"
echo "Format Output: ${tfFormatOutput}"

if (( $tfValidateOutput == 0 && $tfFormatOutput == 0))
then
  echo "Validations passed"
else
  echo "Validations failed"
  exit 1
