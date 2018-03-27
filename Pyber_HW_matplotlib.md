

```python
import pandas as pd
import matplotlib.pyplot as plt
#imported the below for inclusing "Note:" in the diag
from pylab import *
#%matplotlib auto
```


```python
csvpath1='city_data.csv'
csvpath2='ride_data.csv'
rawfile_city=pd.read_csv(csvpath1)
rawfile_city.head(3)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>city</th>
      <th>driver_count</th>
      <th>type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Kelseyland</td>
      <td>63</td>
      <td>Urban</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Nguyenbury</td>
      <td>8</td>
      <td>Urban</td>
    </tr>
    <tr>
      <th>2</th>
      <td>East Douglas</td>
      <td>12</td>
      <td>Urban</td>
    </tr>
  </tbody>
</table>
</div>




```python
rawfile_ride=pd.read_csv(csvpath2)
rawfile_ride.head(3)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>city</th>
      <th>date</th>
      <th>fare</th>
      <th>ride_id</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Sarabury</td>
      <td>2016-01-16 13:49:27</td>
      <td>38.35</td>
      <td>5403689035038</td>
    </tr>
    <tr>
      <th>1</th>
      <td>South Roy</td>
      <td>2016-01-02 18:42:34</td>
      <td>17.49</td>
      <td>4036272335942</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Wiseborough</td>
      <td>2016-01-21 17:35:29</td>
      <td>44.18</td>
      <td>3645042422587</td>
    </tr>
  </tbody>
</table>
</div>




```python
ride_city_filemerge = pd.merge(rawfile_city, rawfile_ride, on="city", how="outer")
ride_city_filemerge.head(3)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>city</th>
      <th>driver_count</th>
      <th>type</th>
      <th>date</th>
      <th>fare</th>
      <th>ride_id</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Kelseyland</td>
      <td>63</td>
      <td>Urban</td>
      <td>2016-08-19 04:27:52</td>
      <td>5.51</td>
      <td>6246006544795</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Kelseyland</td>
      <td>63</td>
      <td>Urban</td>
      <td>2016-04-17 06:59:50</td>
      <td>5.54</td>
      <td>7466473222333</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Kelseyland</td>
      <td>63</td>
      <td>Urban</td>
      <td>2016-05-04 15:06:07</td>
      <td>30.54</td>
      <td>2140501382736</td>
    </tr>
  </tbody>
</table>
</div>




```python
plt.figure(figsize=(10,8))
urban_city=ride_city_filemerge.loc[ride_city_filemerge['type']=='Urban']

urban_city_gp=urban_city.groupby(['city'])
urban_city_gpdf=pd.DataFrame({"Average Fare":urban_city_gp['fare'].mean(),
                            "Total rides per city":urban_city_gp['ride_id'].count()})
plt.scatter(x=urban_city_gpdf["Total rides per city"],y=urban_city_gpdf["Average Fare"],
            s=urban_city_gp["driver_count"].value_counts()*40,color='lightcoral',edgecolors="black",label ='Urban')
    

        
##################
rural_city=ride_city_filemerge.loc[ride_city_filemerge['type']=='Rural']

rural_city_gp=rural_city.groupby(['city'])
rural_city_gpdf=pd.DataFrame({"Average Fare":rural_city_gp['fare'].mean(),
                            "Total rides per city":rural_city_gp['ride_id'].count()})
plt.scatter(x=rural_city_gpdf["Total rides per city"],y=rural_city_gpdf["Average Fare"],
            s=rural_city_gp["driver_count"].value_counts()*40,color='Gold',edgecolors="black",label ='Rural')
    
    
###################    
sburban_city=ride_city_filemerge.loc[ride_city_filemerge['type']=='Suburban']

sburban_city_gp=sburban_city.groupby(['city'])
sburban_city_gpdf=pd.DataFrame({"Average Fare":sburban_city_gp['fare'].mean(),
                            "Total rides per city":sburban_city_gp['ride_id'].count()})
plt.scatter(x=sburban_city_gpdf["Total rides per city"],y=sburban_city_gpdf["Average Fare"],
            s=sburban_city_gp["driver_count"].value_counts()*40,color='lightskyblue',edgecolors="black",label ='Suburban')
    


plt.xlim(0,40)
plt.grid()
plt.xlabel("Total Number of Rides (per city)",fontsize=15)
plt.ylabel("Average Fare($)", fontsize=15)
plt.title("Pyber Ride Sharing Data(2016)", fontsize=15)
plt.legend(prop={'size': 20})
figtext(.95,.6,"NOTE: Circle size correlates with driver count per city", rotation='horizontal',fontsize=20)


```




    Text(0.95,0.6,'NOTE: Circle size correlates with driver count per city')




![png](output_4_1.png)



```python
#% of Total Fares by City Type

total_fare=ride_city_filemerge.groupby('type')
total_fare_df=pd.DataFrame({"Total fare by city type":total_fare['fare'].sum()})
total_fare_df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Total fare by city type</th>
    </tr>
    <tr>
      <th>type</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Rural</th>
      <td>4255.09</td>
    </tr>
    <tr>
      <th>Suburban</th>
      <td>20335.69</td>
    </tr>
    <tr>
      <th>Urban</th>
      <td>40078.34</td>
    </tr>
  </tbody>
</table>
</div>




```python
colors = ['Gold', 'lightskyblue' , 'lightCoral']
explode = (0, 0, 0.05)
total_fare_df.plot(kind='pie',explode=explode, figsize=(10,8),colors=colors, autopct="%1.1f%%" ,shadow=True, startangle=90,
                    subplots='True',title="% of Total Fare by City Types",fontsize=15)
plt.axis("equal")
plt.ylabel(" ")

```




    Text(0,0.5,' ')




![png](output_6_1.png)



```python
#% of Total Rides by City Type
total_rides=ride_city_filemerge.groupby('type')
total_rides_df=pd.DataFrame({"Total rides by city type":total_rides['ride_id'].count()})
total_rides_df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Total rides by city type</th>
    </tr>
    <tr>
      <th>type</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Rural</th>
      <td>125</td>
    </tr>
    <tr>
      <th>Suburban</th>
      <td>657</td>
    </tr>
    <tr>
      <th>Urban</th>
      <td>1625</td>
    </tr>
  </tbody>
</table>
</div>




```python
colors = ['Gold', 'lightskyblue' , 'lightCoral']
explode = (0, 0, 0.05)
total_rides_df.plot(kind='pie',explode=explode, figsize=(10,8),colors=colors, autopct="%1.1f%%" ,shadow=True, startangle=90,
                    subplots='True',title="% of Total Rides by City Type",fontsize=15)
plt.axis("equal")
plt.ylabel(" ")
```




    Text(0,0.5,' ')




![png](output_8_1.png)



```python
#% of Total Drivers by City Type
total_drivers=rawfile_city.groupby('type')
total_drivers_df=pd.DataFrame({"Total drivers by city type":total_drivers['driver_count'].sum()})
total_drivers_df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Total drivers by city type</th>
    </tr>
    <tr>
      <th>type</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Rural</th>
      <td>104</td>
    </tr>
    <tr>
      <th>Suburban</th>
      <td>638</td>
    </tr>
    <tr>
      <th>Urban</th>
      <td>2607</td>
    </tr>
  </tbody>
</table>
</div>




```python
colors = ['Gold', 'lightskyblue' , 'lightCoral']
explode = (0, 0, 0.05)
total_drivers_df.plot(kind='pie',explode=explode, figsize=(10,8),colors=colors, autopct="%1.1f%%" ,shadow=True, startangle=90,
                    subplots='True',title="% of Total Rides by City Type",fontsize=15)
plt.axis("equal")
plt.ylabel(" ")
```




    Text(0,0.5,' ')




![png](output_10_1.png)

