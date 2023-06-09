import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv('max.csv')

df_sorted = df.sort_values('max(Matterpollution)', ascending=False)
top_5_countries = df_sorted.head(5)

fig, axs = plt.subplots(3, 1, figsize=(8, 12))

axs[0].plot(top_5_countries['Entity'], top_5_countries['max(Matterpollution)'])
axs[0].set_ylabel('Max Matter Pollution')
axs[0].set_title('Max Matter Pollution Levels of Top 5 Countries')

axs[1].plot(top_5_countries['Entity'], top_5_countries['max(OzonePollution)'])
axs[1].set_ylabel('Max Ozone Pollution')
axs[1].set_title('Max Ozone Pollution Levels of Top 5 Countries')

axs[2].plot(top_5_countries['Entity'], top_5_countries['max(concentration)'])
axs[2].set_ylabel('Max Concentration')
axs[2].set_title('Max Concentration Levels of Top 5 Countries')

axs[-1].set_xlabel('Countries')

plt.tight_layout()

plt.show()