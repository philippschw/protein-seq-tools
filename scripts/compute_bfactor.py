from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options  
from selenium.webdriver.chrome.service import Service

from glob import glob 
import click 
from pathlib import Path
import os

chrome_options = Options()  
chrome_options.add_argument("--headless")
chrome_options.binary_location = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
s = Service('/usr/local/bin/chromedriver')
driver = webdriver.Chrome(service=s, chrome_options=chrome_options)  

url = 'https://swift.cmbi.umcn.nl/servers/html/listavb.html'


@click.command()
@click.option('--inputdir', type=str)
@click.option('--outputdir', type=str)   
def main(
    inputdir,
    outputdir
    ):
    if not os.path.exists(outputdir):
        os.makedirs(outputdir)
        
    files = glob(f"{inputdir}/*.pdb")
    for file in files:
        filename = Path(file).name
        driver.get(url)
        elem = driver.switch_to.active_element
        elem = WebDriverWait(driver, 5).until(lambda driver: driver.find_element(By.NAME, '&FIL1'))
        elem.send_keys(file)
        submit_elem = WebDriverWait(driver, 5).until(lambda driver: driver.find_element(By.NAME, 'SubmitButton'))
        submit_elem.click()
        result = WebDriverWait(driver, 10).until(EC.visibility_of_element_located((By.CSS_SELECTOR, "pre"))).text
        with open(f"{outputdir}/{filename}.txt", "a") as f:
            print(result, file=f)
    

if __name__ == '__main__':
    main()

