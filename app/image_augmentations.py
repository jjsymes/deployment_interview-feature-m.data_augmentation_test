from PIL import Image
import random

def random_augmentation(image: Image):
    augmentations = [rotate, fliplr, fliptb, do_nothing]
    func = random.choice(augmentations)
    return func(image)

def do_nothing(image: Image):
    return image

def fliplr(image: Image):
    return image.transpose(Image.FLIP_LEFT_RIGHT)

def fliptb(image: Image):
    return image.transpose(Image.FLIP_TOP_BOTTOM)

def rotate(image: Image):
    return image.rotate(random.randint(0,365))
