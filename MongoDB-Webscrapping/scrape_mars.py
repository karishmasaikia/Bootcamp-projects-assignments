from splinter import Browser
from bs4 import BeautifulSoup
from selenium import webdriver
import pandas as pd
import time


def init_browser():
    
    executable_path = {"executable_path": "chromedriver.exe"}
    browser=Browser("chrome", **executable_path, headless=True)
    return browser
    

def scrape():
    
    # JPL Mars Space Images - Featured Image

    browser = init_browser()
    url = 'https://www.jpl.nasa.gov/spaceimages/?search=&category=Mars'
    browser.visit(url)
    time.sleep(2)

    full_image_elem = browser.find_by_id('full_image')
    full_image_elem.click()
    time.sleep(2)
    more_info_elem = browser.find_link_by_partial_text('more info')
    more_info_elem.click()
    time.sleep(2)

    html = browser.html
    image_soup = BeautifulSoup(html, 'html.parser')

    image_url = image_soup.find('figure', class_='lede')
    time.sleep(1)
    image_url_new=image_url.img['src']

    featured_image_url=f'https://www.jpl.nasa.gov{image_url_new}'

    # Mars Weather

    url="https://twitter.com/marswxreport?lang=en"
    browser.visit(url)
    time.sleep(2)

    html = browser.html
    soup = BeautifulSoup(html, 'html.parser')
    tweet=soup.find('p', class_='TweetTextSize TweetTextSize--normal js-tweet-text tweet-text',\
                    attrs={"lang":"en", "data-aria-label-part":"0"})

    mars_weather=tweet.text

    # Mars Facts
    url = 'https://space-facts.com/mars/'
    tables = pd.read_html(url)
    time.sleep(1)
    df=tables[0]
    df.columns = ['Planet Mars Parameters', 'Values']
    df.set_index('Planet Mars Parameters', inplace=True)
    table=df.to_html()
    table = table.replace('\n', '')

    # Mars Hemispheres

    ori_url='https://astrogeology.usgs.gov'
    url = 'https://astrogeology.usgs.gov/search/results?q=hemisphere+enhanced&k1=target&v1=Mars'
    browser.visit(url)
    time.sleep(2)
    html = browser.html
    soup = BeautifulSoup(html, 'html.parser')
    results=soup.find_all('a',class_="itemLink product-item")

    hemisphere_image_urls=[]
    

    for result in results:
        
    #as there was duplication of paths, so this condition was used
        if(result.h3):
            text_hemisphere=result.h3.text
            title_list=text_hemisphere.split('Enhanced')
            title=title_list[0]
            # print(title)
        
            image_link_url=result['href']
            new_url=ori_url + image_link_url
        
            url_img = new_url
            browser.visit(url_img)
            time.sleep(2)
            html_img = browser.html
            soup_img= BeautifulSoup(html_img, 'html.parser')
            
            
            image_urls=soup_img.find_all('div',class_='downloads')
            
            for imageurl in image_urls:
#             if(image_url.a.text=="Sample"):
                image_url=imageurl.a['href']
                    
                hemisphere_details = {
                'title': title,
                'img_url': image_url}
            
                
                hemisphere_image_urls.append(hemisphere_details)

    
    scrape_dict ={ "Featured_Image": featured_image_url,
            "Mars_Weather":mars_weather,
            "Mars_Facts": table,
            "Mars_Hemispheres":hemisphere_image_urls}
    
    
    # print(scrape_dict['Mars_Hemispheres'][0]['title'])
    # print(scrape_dict['Featured_Image'])

    return scrape_dict

# y=scrape()



        

