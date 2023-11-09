import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import streamlit as st
from babel.numbers import format_currency
sns.set(style='dark')

# Helper function yang dibutuhkan untuk menyiapkan berbagai dataframe

def create_yearly_rental_df(df):
    yearly_rental_df = df.groupby('yr').agg({
        'instant':'nunique',
        'cnt':'sum'
    }).reset_index()
    yearly_rental_df.rename(columns={
        'yr':'year',
        'instant':'number_user',
        'cnt':'total_rental'
    }, inplace=True)
    return yearly_rental_df

def create_monthly_rental_df(df):
    monthly_rental_df = df.groupby('mnth').agg({
        'instant':'nunique',
        'cnt':'sum'
    }).reset_index()
    monthly_rental_df.rename(columns={
        'mnth':'month',
        'instant':'number_user',
        'cnt':'total_rental'
    }, inplace=True)
    return monthly_rental_df

def create_daily_rental_df(df):
    daily_rental_df = df.groupby('weekday').agg({
        'instant':'nunique',
        'cnt':'sum'
    }).reset_index()
    
    day_order = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
    daily_rental_df['weekday'] = pd.Categorical(daily_rental_df['weekday'], categories=day_order, ordered=True)
    daily_rental_df = daily_rental_df.sort_values('weekday')
    
    daily_rental_df.rename(columns={
        'weekday':'day',
        'instant':'number_user',
        'cnt':'total_rental'
    }, inplace=True)
    return daily_rental_df

def create_hourly_rental_df(df):
    hourly_rental_df = data.groupby('hr').agg({
        'instant':'nunique',
        'cnt':'sum'
    }).reset_index()

    hourly_rental_df.rename(columns={
        'hr':'hour',
        'instant':'number_user',
        'cnt':'total_rental'
    }, inplace=True)
    return hourly_rental_df

def create_season_rental_df(df):
    season_rental_df = data.groupby('season')['cnt'].sum().sort_values(ascending=False).reset_index()

    season_rental_df.rename(columns={
        'cnt':'total'
    }, inplace=True)
    return season_rental_df

# Load cleaned data
data = pd.read_csv("data.csv")

data['dteday'] = pd.to_datetime(data['dteday'])

# Filter data
min_date = data["dteday"].min()
max_date = data["dteday"].max()

with st.sidebar:
    # Menambahkan logo perusahaan
    # st.image("https://github.com/dicodingacademy/assets/raw/main/logo.png")
    st.title('Dashboard Rental Bike')
    
    # Mengambil start_date & end_date dari date_input
    start_date, end_date = st.date_input(
        label='Rentang Waktu',min_value=min_date,
        max_value=max_date,
        value=[min_date, max_date]
    )

main_df = data[(data["dteday"] >= str(start_date)) & 
                (data["dteday"] <= str(end_date))]

# # Menyiapkan berbagai dataframe
yearly_rental_df = create_yearly_rental_df(main_df)
monthly_rental_df = create_monthly_rental_df(main_df)
daily_rental_df = create_daily_rental_df(main_df)
hourly_rental_df = create_hourly_rental_df(main_df)
season_rental_df = create_season_rental_df(main_df)

# plot number of rental per year
st.header('Dashboard Rental Bike :bike:')
st.subheader('Total Rental by User')

col1, col2 = st.columns(2)
 
with col1:
    total_rental = main_df['cnt'].sum()
    st.metric("Total Rental", value=total_rental)
 
with col2:
    col1, col2 = st.columns(2)
    with col1:
        registered_user = main_df['registered'].sum()
        st.metric('Registered User', value=registered_user)
    with col2:
        casual_user = main_df['casual'].sum()
        st.metric('Casual User', value=casual_user)

# Total rental per year
st.subheader('Total Rental per Year')
fig, ax = plt.subplots(figsize=(20, 10))
colors = ["#D3D3D3", "#90CAF9"]
sns.barplot(
    x='year',
    y='total_rental',
    data=yearly_rental_df,
    palette=colors,
    ax=ax
)
ax.set_title("Number of Customer by Gender", loc="center", fontsize=50)
ax.set_ylabel(None)
ax.set_xlabel(None)
ax.tick_params(axis='x', labelsize=35)
ax.tick_params(axis='y', labelsize=30)
st.pyplot(fig)

# Total rental per month
st.subheader('Total Rental per Month')
fig, ax = plt.subplots(figsize=(16, 8))
ax.plot(
    monthly_rental_df["month"],
    monthly_rental_df["total_rental"],
    marker='o', 
    linewidth=2,
    color="#90CAF9"
)
ax.tick_params(axis='y', labelsize=20)
ax.tick_params(axis='x', labelsize=15)

st.pyplot(fig)

# Total rental per day
st.subheader('Total Rental per Day')
fig, ax = plt.subplots(figsize=(20, 10))
colors = ["#D3D3D3",'#D3D3D3',"#D3D3D3",'#72BCD4',"#72BCD4",'#72BCD4','#D3D3D3']
sns.barplot(
    x='day',
    y='total_rental',
    data=daily_rental_df,
    palette=colors,
    ax=ax
)
ax.set_title("Number of Customer by Gender", loc="center", fontsize=50)
ax.set_ylabel(None)
ax.set_xlabel(None)
ax.tick_params(axis='x', labelsize=20)
ax.tick_params(axis='y', labelsize=30)
st.pyplot(fig)

# Total rental per hour
st.subheader('Total Rental per Hour')
fig, ax = plt.subplots(figsize=(16, 8))
ax.plot(
    hourly_rental_df["hour"],
    hourly_rental_df["total_rental"],
    marker='o', 
    linewidth=2,
    color="#90CAF9"
)
ax.tick_params(axis='y', labelsize=20)
ax.tick_params(axis='x', labelsize=15)

st.pyplot(fig)

# Total rental by Season
st.subheader('Total Rental by Season')
fig, ax = plt.subplots(figsize=(20, 10))
colors = ["#72BCD4",'#D3D3D3',"#D3D3D3",'#D3D3D3']
sns.barplot(
    x='season',
    y='total',
    data=season_rental_df,
    palette=colors,
    ax=ax
)
ax.set_title("Number of Customer by Gender", loc="center", fontsize=50)
ax.set_ylabel(None)
ax.set_xlabel(None)
ax.tick_params(axis='x', labelsize=20)
ax.tick_params(axis='y', labelsize=30)
st.pyplot(fig)

st.caption('Copyright (c) Fadli 2023')