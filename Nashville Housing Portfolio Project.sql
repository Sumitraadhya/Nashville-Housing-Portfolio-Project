/*
Cleaning Data in SQL Queries
*/
Select * from NashvilleHousing

-- Standardize Date Format

Select SaleDateConverted, Convert(Date, saledate) as Date from NashvilleHousing

-- If it doesn't Update properly

Update  NashvilleHousing
SET SaleDate=Convert(Date, saledate) 

Alter table NashvilleHousing
Add SaleDateConverted Date;

Update  NashvilleHousing
SET SaleDateConverted=Convert(Date, saledate) 

-- Populate Property Address data

Select *---Propertyaddress
from NashvilleHousing
order by ParcelID

---where Propertyaddress is Null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a JOIN NashvilleHousing b 
ON a.ParcelID=b.ParcelID And  a.UniqueID <> b.UniqueID
where a.PropertyAddress is NUll

Update a
SET Propertyaddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a JOIN NashvilleHousing b 
ON a.ParcelID=b.ParcelID And  a.UniqueID <> b.UniqueID
where a.PropertyAddress is NUll

-- Breaking out Address into Individual Columns (Address, City, State)

Select Propertyaddress
from NashvilleHousing
---order by ParcelID
Select Propertyaddress, SUBSTRING(Propertyaddress, 1, CHARINDEX (',', Propertyaddress)-1), 
SUBSTRING(Propertyaddress, CHARINDEX (',', Propertyaddress)+1, LEN(Propertyaddress))
from NashvilleHousing

Alter table NashvilleHousing
Add PropertySplitAddress nVarchar(255);

Update  NashvilleHousing
SET PropertySplitAddress=SUBSTRING(Propertyaddress, 1, CHARINDEX (',', Propertyaddress)-1);

Alter table NashvilleHousing
Add PropertySplitCity nVarchar(255);

Update  NashvilleHousing
SET PropertySplitCity=SUBSTRING(Propertyaddress, CHARINDEX (',', Propertyaddress)+1, LEN(Propertyaddress));

Select * from NashvilleHousing

Select OwnerAddress from NashvilleHousing;

Select PARSENAME(Replace(OwnerAddress, ',', '.'),3),
PARSENAME(Replace(OwnerAddress, ',', '.'),2),
PARSENAME(Replace(OwnerAddress, ',', '.'),1) from NashvilleHousing;

Alter table NashvilleHousing
Add OwnerSplitAddress nVarchar(255);

Update  NashvilleHousing
SET OwnerSplitAddress=PARSENAME(Replace(OwnerAddress, ',', '.'),3);

Alter table NashvilleHousing
Add OwnerSplitCity nVarchar(255);

Update  NashvilleHousing
SET OwnerSplitCity=PARSENAME(Replace(OwnerAddress, ',', '.'),2);

Alter table NashvilleHousing
Add OwnerSplitState nVarchar(255);

Update  NashvilleHousing
SET OwnerSplitState=PARSENAME(Replace(OwnerAddress, ',', '.'),1);

Select * from NashvilleHousing

-- Change Y and N to Yes and No in "Sold as Vacant" field
Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
from NashvilleHousing
Group BY SoldAsVacant
Order By 2

Select SoldAsVacant,
Case 
 When SoldAsVacant='Y' then 'Yes'
 When SoldAsVacant='N' then 'No'
 Else SoldAsVacant
END
From  NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant=Case
When SoldAsVacant='Y' then 'Yes'
 When SoldAsVacant='N' then 'No'
 Else SoldAsVacant
 END
 
-- Remove Duplicates---
With RowNumCTE AS( 
Select *,
   ROW_NUMBER() OVER(
   Partition BY ParcelID,
                Propertyaddress,
                SalePrice,
                SaleDate,
                LegalReference
               ORDER BY
              UniqueID
			  ) row_num
From NashvilleHousing
----Order By ParcelID
)
Select * from RowNumCTE
where row_num >1
---order by Propertyaddress;


-- Delete Unused Columns--
Select * from NashvilleHousing

Alter Table NashvilleHousing
Drop Column Owneraddress, Propertyaddress, taxDistrict, saledate
