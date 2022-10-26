#!/usr/bin/env python
# coding: utf-8

# In[2]:


import os
import pandas as pd
import matplotlib as plt
import requests
from geopy.geocoders import Nominatim
from geopy import ArcGIS
from ipyleaflet import Map,  MeasureControl
import ipywidgets
import geopandas
from geopy import ArcGIS
import matplotlib.pyplot
from pandas_profiling import ProfileReport
from geopy.geocoders import Nominatim
from geopy import distance
from math import sin, cos, sqrt, atan2
from sklearn.neighbors import DistanceMetric
from math import radians
import pandas as pd
import numpy as np
from math import radians
import pandas as pd
import numpy as np
import haversine as hs
import folium 


# In[2]:


geolocator = Nominatim()
#Assigning Arc to ArcGIS object
#dir(geopy)
Arc = ArcGIS()


# In[4]:


#conda install -c conda-forge pyogrio
os.chdir('Desktop/mojo')


# In[5]:


#Reading in the customers
df = pd.read_csv('customers.csv')


# In[8]:


#Point to the addresses witin the frame 
df["Coordinates"] = df.billaddress.apply(Arc.geocode)


# In[11]:


#Creating seperate values for lat and long
df['latitude'] = df['Coordinates'].apply(lambda x: x.latitude)
df['longitude'] = df['Coordinates'].apply(lambda y: y.longitude)


# In[122]:


#Saving the file to a csv so you dont have to re run Arc
df.to_csv('spatial_info.csv', index = False)


# In[5]:


#Reading the file back into python that you just saved to a csv
df = pd.read_csv('spatial_info.csv')
df1 = pd.read_csv('spatial_info.csv')


# In[7]:


#Plitting the address to get the name of the town and state 
split_1 = df.billaddress.str.split("'", expand = True)[1]
split_2 = split_1.str.split('0', expand = True)[0]
df['town'] = split_2


# In[8]:


#Saving the file to a csv so you dont have to re run Arc
df.to_csv('geo_spatial.csv', index = False)


# In[23]:


#Importing the new data set so you dont have to load the arc.geocode
df1 = pd.read_csv('spatial_info.csv')


# In[16]:


#Choosing the columns needed to calculate the distances 
distance = df[['accountnum', 'long_lat','latitude', 'longitude']]


# In[18]:


#Converting each of the lat long points to radians
distance['lat'] = np.radians(distance['latitude'])
distance['lon'] = np.radians(distance['longitude'])


# In[19]:


#Assigning DistanceMetric.get_metric('haversine') to dist to use to calculate the distances 
dist = DistanceMetric.get_metric('haversine')


# In[20]:


#Dataframe using pairwise on lat and long to get distances
distance_matrix = pd.DataFrame(dist.pairwise(distance[['lat','lon']].to_numpy())*6373,  columns=distance.accountnum, index=distance.accountnum)


# In[21]:


#Putting the NA as zeros so the min distance doesnt return 0 
distance_matrix.replace(to_replace = 0, value = pd.NA, inplace=True)


# In[ ]:


distance_matrix.to_csv('distances.csv', index = False)

