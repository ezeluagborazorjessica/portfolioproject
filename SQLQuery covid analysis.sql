Select*
from portfolioproject..CovidDeaths$
order by 3,4


--Select*
--from protfolioproject..CovidVaccinations$
--order by 3,4

select location,date,total_cases,new_cases,total_deaths,population 
 from portfolioproject..CovidDeaths$
 order by 1,2

 --select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage
 --from protfolioproject..CovidDeaths$
 --where location like '%nigeria%'
 --order by 1,2 

 select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage
 from portfolioproject..CovidDeaths$
 where location like '%states%'
 order by 1,2 

 select location,date,population,total_cases, (total_cases/population)*100 as Deathpercentage
 from portfolioproject..CovidDeaths$
 --where location like '%states%'
 order by 1,2

 select location,population, MAX(total_cases)as highestinfectioncount, Max((total_cases/population))*100 as percentagepopulationinfected
 from portfolioproject..CovidDeaths$
 --where location like '%nigeria%'
 group by location,population
 order by percentagepopulationinfected desc

  select location, MAX(cast(total_deaths as int)) as Totaldeathcount
 from portfolioproject..CovidDeaths$
 where location like '%nigeria%'
 --where continent is not null
 group by location
 order by Totaldeathcount desc

 
  
select date,SUM(new_cases)as sumofnewcases
from portfolioproject..CovidDeaths$
where continent is not null
group by date
order by 1,2


select SUM(new_cases)as totalcases,sum(cast(new_deaths as int))as totaldeaths,
sum(cast(new_deaths as int))/SUM(new_cases)*100 as deathpercentage
from portfolioproject..CovidDeaths$
where continent is not null
--group by date 
order by 1,2

select *
from portfolioproject..CovidDeaths$ dea
join portfolioproject..CovidVaccinations$ vac
  on dea.location = vac.location
  and dea.date = vac.date

select dea.continent,dea.date,dea.location,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location,dea.date)as rolledonvaccination
from portfolioproject..CovidDeaths$ dea
join portfolioproject..CovidVaccinations$ vac
  on vac.location = dea.location
  and vac.date = dea.date
  where dea.continent is not null 
  order by continent



--using CTE

with PopvsVac (continent,location,date,population,new_vaccinations,rolledonvaccination)
as 
(
select dea.continent,dea.date,dea.location,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location,dea.date)as rolledonvaccination
from portfolioproject..CovidDeaths$ dea
join portfolioproject..CovidVaccinations$ vac
  on vac.location = dea.location
  and vac.date = dea.date
  where dea.continent is not null 
  --order by continent
 )
  select*,(rolledonvaccination/population)*100 as percentagevaccinated
  from popvsvac
  

  --using TEMP TABLE

  drop table if exists percentagevaccinated
  create table percentagevaccinated 
  (
  continent nvarchar(255),
  Date Datetime,
  location nvarchar(255),
  population numeric,
  new_vaccionations numeric,
  rolledonvaccination numeric,
  )
insert into percentagevaccinated
select dea.continent,dea.date,dea.location,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location,dea.date)as rolledonvaccination
from portfolioproject..CovidDeaths$ dea
join portfolioproject..CovidVaccinations$ vac
  on vac.location = dea.location
  and vac.date = dea.date
  --where dea.continent is not null 
 -- order by continent

   select*, (rolledonvaccination/population)*100
   from percentagevaccinated


 --creating views 

 create view percentagevaccinated1 as
 select dea.continent,dea.date,dea.location,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location,dea.date)as rolledonvaccination
from portfolioproject..CovidDeaths$ dea
join portfolioproject..CovidVaccinations$ vac
  on vac.location = dea.location
  and vac.date = dea.date
 where dea.continent is not null 
 -- order by continent  

 create view sumofdeathcount1 as 
   select location, MAX(cast(total_deaths as int)) as Totaldeathcount
 from portfolioproject..CovidDeaths$
 --where location like '%nigeria%'
 where continent is not null
 group by location
-- order by Totaldeathcount desc

create view populationinfected as
 select location,population, MAX(total_cases)as highestinfectioncount, Max((total_cases/population))*100 as percentagepopulationinfected
 from portfolioproject..CovidDeaths$
 --where location like '%nigeria%'
 group by location,population
 --order by percentagepopulationinfected desc