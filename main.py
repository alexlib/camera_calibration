import cv2 as cv
from pathlib import Path
from PIL import Image
import numpy as np
from enum import Enum
from algorithm.zhang2000.calibration import calibrate_with_zhang_method
from algorithm.opencv.calibration import calibrate_with_opencv

class CalibMethod(Enum):
    ZHANG2000 = "zhang2000"
    OPENCV = "opencv"


INPUT_FILES = {
    "img_folder": Path("./data")
}

CONFIG = {
    "calibration_method": CalibMethod.OPENCV,
    "checkerboard": {
        "num_corners": (9, 6),  # ([numbers of corners per column], [number of corners per row])
        "checker_size": 21.5,  # mm
        "show_figure": False,
    }
}


def run_scripts(input_files: dict, config: dict):

    img_file_list = list(input_files["img_folder"].glob("*.jpg"))
    img_file_list.sort()

    if config["calibration_method"] == CalibMethod.ZHANG2000:
        calibrate_with_zhang_method(config, img_file_list)
    elif config["calibration_method"] == CalibMethod.OPENCV:
        calibrate_with_opencv(config, img_file_list)
    else:
        raise NotImplementedError()


if __name__ == "__main__":
    run_scripts(input_files=INPUT_FILES, config=CONFIG)
