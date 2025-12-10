Select *
From [Portfolio Project].[dbo].[CovidDeaths]
where continent is not null
order by 3,4

--Select *
--From CovidVaccinations
--order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Project].[dbo].[CovidDeaths]
order by 1,2


--Looking at Total_cases vs Total_deaths
--show likelihood of dying if you have covid

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project].[dbo].[CovidDeaths] 
where location like '%Nigeria%'
order by 1,2


--Looking at Total_cases vs Population
--shows population percentage with covid

Select location, date, population, total_cases, (total_cases/population)*100 as Infected_Population_Percentage
From [Portfolio Project].[dbo].[CovidDeaths] 
--where location like '%Nigeria%'
order by 1,2


--Highest Infection Rate Compared to Population per Country

Select location, population, MAX(total_cases)as HighestInfectionCount , MAX((total_cases/population))*100 as Infected_Population_Percentage
From [Portfolio Project].[dbo].[CovidDeaths] 
--where location like '%Nigeria%'
Group by location, population
order by Infected_Population_Percentage DESC


--Showing the countries with the highest death rate per population

Select location, MAX(cast(total_deaths as int))as TotalDeathCount 
From [Portfolio Project].[dbo].[CovidDeaths] 
--where location like '%Nigeria%'
where continent is not null
Group by location
order by TotalDeathCount  DESC


--Showing the continent with the highest death rate per population

Select continent, SUM(CONVERT(int,new_deaths))as TotalDeathCount 
From [Portfolio Project].[dbo].[CovidDeaths] 
where continent!=''
Group by continent
order by TotalDeathCount  DESC


Select SUM(new_cases) as Total_cases, SUM(CAST(new_deaths as int)) as Total_deaths, (SUM(new_cases)/ SUM(CAST(new_deaths as int)))*100 as DeathPercentage
From [Portfolio Project].[dbo].[CovidDeaths] 
--where location like '%Nigeria%'
where continent is not null
order by 1,2


--Looking at Total Population vs Vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as Rolling_Vaccine_Count
From [Portfolio Project].[dbo].[CovidDeaths] dea
JOIN [Portfolio Project].[dbo].[CovidVaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
Order by 2,3




--Using CTE

With PopVsVac(Continent, Location, Date,  Population, New_Vaccinations, Rolling_Vaccine_Count)
as
(
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as Rolling_Vaccine_Count
	From [Portfolio Project].[dbo].[CovidDeaths] dea
	JOIN [Portfolio Project].[dbo].[CovidVaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--Order by 2,3
)
Select *,(Rolling_Vaccine_Count/Population)*100
From PopVsVac


--TEMP Table

DROP Table If exist #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rolling_Vaccine_Count numeric
)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as Rolling_Vaccine_Count
From [Portfolio Project].[dbo].[CovidDeaths] dea
JOIN [Portfolio Project].[dbo].[CovidVaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--Order by 2,3

Select *,(Rolling_Vaccine_Count/Population)*100
From #PercentPopulationVaccinated




CREATE VIEW PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as Rolling_Vaccine_Count
From [Portfolio Project].[dbo].[CovidDeaths] dea
JOIN [Portfolio Project].[dbo].[CovidVaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--Order by 2,3


Create View PPV as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as Rolling_Vaccine_Count
From [Portfolio Project].[dbo].[CovidDeaths] dea
JOIN [Portfolio Project].[dbo].[CovidVaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--Order by 2,3

Select *
From PercentPopulationVaccinated