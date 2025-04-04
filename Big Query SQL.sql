create table kimia_farma.kf_analisa as
with cte1 as
(select 
distinct product_id, price,
case
  when price <= 50000 then 0.1
  when price > 50000 and price <= 100000 then 0.15
  when price > 100000 and price <= 300000 then 0.2
  when price > 300000 and price <= 500000 then 0.25
  else 0.3
end persentase_gross_laba
from `kimia_farma.kf_final_transaction`
)
select
tr.transaction_id,
tr.date,
tr.branch_id,
br.branch_name,
br.kota,
br.provinsi,
br.rating rating_cabang,
tr.customer_name,
tr.product_id,
pr.product_name,
pr.price actual_price,
tr.discount_percentage,
c1.persentase_gross_laba,
tr.price * (1 - tr.discount_percentage) nett_sales,
(tr.price * (1 - tr.discount_percentage)) * c1.persentase_gross_laba nett_profit,
tr.rating rating_transaksi
from `kimia_farma.kf_final_transaction` tr 
  join `kimia_farma.kf_kantor_cabang` br 
  on tr.branch_id = br.branch_id
  join `kimia_farma.kf_product` pr
  on tr.product_id = pr.product_id
  join cte1 c1
  on tr.product_id = c1.product_id