import pytest
from PIL import Image
from app.image_augmentations import fliptb

def test_fliptb():
    image = Image.open("tests/fixtures/augmented_image.jpg")
    expected_augmented_image = image.transpose(Image.FLIP_TOP_BOTTOM)
    assert fliptb(image) == expected_augmented_image
