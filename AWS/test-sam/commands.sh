# create S3 bucket
aws s3 mb s3://umidjon-code-sam

# packaging the sam codes (local -> s3)
# in our case it uploads/packages the "app.py" to s3 bucket
# and generates a new SAM file that URi is the S3 file location
aws cloudformation package --s3-bucket umidjon-code-sam --template-file \
    template.yaml --output-template-file gen/template-generated.yaml
                    # || 
                    # \/
# --s3-bucket umidjon-code-sam -> where will it be packaged
# --template-file template.yaml -> the local address of SAM file
# --output-template-file gen/template-generated.yaml -> where the output will be downloaded (local)


# when you create run the shell above, you will get deploy shell template as a response:
# Deploying the package (s3 -> cloudformation)
# it craetes 'changeset' that tells to lambda: deffernce of current deployed code and packaged code
aws cloudformation deploy --template-file gen/template-generated.yaml \
    --stack-name fuck-it --capabilities CAPABILITY_IAM
                    # ||
                    # \/
#  --template-file gen/template-generated.yaml -> local address of generated SAM file
#  --stack-name fuck-it -> cloudformation stack name
#  --capabilities CAPABILITY_IAM -> to create resources CloudFormation need to create IAM 
                # roles. So we must give cloudFormation IAM Capability to create IAM role
# After this command proper resources (Lambda function, IAM role) are created by CloudFormation