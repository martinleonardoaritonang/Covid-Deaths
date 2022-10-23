
-- data that we are using in tableau
--all new cases, new deaths, and percentage of deaths to cases between 2020-01-01 and 2022-10-20

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
		(sum(cast(new_deaths as int)) / sum(new_cases) ) *100 as death_percentage
from covid_deaths 
where continent is not null 

-- highest deaths in each location
select continent, sum(cast(new_deaths as int)) as total_deaths_count
from covid_deaths
where continent is not null and new_deaths is not null
group by continent

-- percentage of highest infected to population in each location 
select  location,population,max(total_cases) as highest_infected,
	round(max((total_cases/population))*100,3) as infected_percentage
from covid_deaths
where total_cases is not null and population is not null
group by location,population
order by infected_percentage desc

-- percentage of highest infected to population in each location  and date
select  location,population,date,max(total_cases) as highest_infected,
	round(max((total_cases/population))*100,3) as infected_percentage
from covid_deaths
where total_cases is not null and population is not null
group by location,population,date
order by infected_percentage desc

-- more exploration

select cd.continent, cd.location, cd.date, cd.population,cv.new_vaccinations,
		sum(cast(cv.new_vaccinations as bigint)) over (partition by cd.location) as total_vaccinations_location
from covid_deaths as cd
inner join
covid_vaccinations as cv
on cd.date=cv.date and cd.location=cv.location
where new_vaccinations is not null
order by 2,3

with sub as(select cd.continent, cd.location,cd.date, cd.population,cv.new_vaccinations,
		sum(cast(cv.new_vaccinations as bigint)) over (partition by cd.location order by cd.location,cd.date) as vaccinations_count
from covid_deaths as cd
join covid_vaccinations as cv
on cd.location= cv.location
and cd.date = cv.date
where cd.continent is not null and new_vaccinations is not null)

select *, round((vaccinations_count/population)*100,2) as vaccinations_count_percentage
from sub





