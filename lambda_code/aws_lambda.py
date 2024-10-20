import logging
import boto3
from io import BytesIO
from PIL import Image
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_function(event):
    # Register the event content
    logger.info(f"event: {event}")

    # Extract the bucket name and the key from the notificacion file of the S3 event
    bucket = event["Records"][0]["s3"]["bucket"]["name"]
    key = event["Records"][0]["s3"]["object"]["key"]

    # Destine bucket name to storage the thumbnail
    thumbnail_bucket = "thumbnail-image-bucket-hg01"
    thumbnail_name, thumbnail_ext = os.path.splitext(key) # Split the main file name in name and extension
    thumbnail_key = f"{thumbnail_name}_thumbnail{thumbnail_ext}" # new name to the thumbnail

    # Register the name of buckets and files to be modifies
    logger.info(f"Bucket name: {bucket}, file name: {key}, Thumbnail Bucket name: {thumbnail_bucket}, file name: {thumbnail_key}")

    s3_client = boto3.client('s3') # Client to use S3 Buckets

    # upload the image and define the size of the main image
    file_byte_string = s3_client.get_object(Bucket=bucket, Key=key)['Body'].read()
    img = Image.open(BytesIO(file_byte_string))
    logger.info(f"Size before compression: {img.size}")

    # Define the new image size max 500x500 pixels
    img.thumbnail((500,500), Image.ANTIALIAS)
    logger.info(f"Size after compression: {img.size}")

    # Create a buffer in memory to storage the thumbnail in format JEPG
    buffer = BytesIO()
    img.save(buffer, "JPEG")
    buffer.seek(0)

    # Upload the thumbnail to the target bucket
    sent_data = s3_client.put_object(Bucket=thumbnail_bucket, Key=thumbnail_key, Body=buffer)

    # upload check with the HTTP code 
    if sent_data['ResponseMetadata']['HTTPStatusCode'] != 200:
        raise Exception('Failed to upload image {} to bucket {}'.format(key, bucket))

    return event