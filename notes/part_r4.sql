-- простые оконные функции
RANK OVER (ORDER BY username);
RANK OVER (PARTITION BY city ORDER BY username);

SELECT invoices.invoice_id, invoices.invoice_date, invoices.customer_id, trans.transaction_amount,
    LAG(trans.transaction_amount) OVER (PARTITION BY invoices.customer_id ORDER BY invoices.invoice_id),
    LEAD(trans.transaction_amount) OVER (PARTITION BY invoices.customer_id ORDER BY invoices.invoice_id),
    MAX(trans.transaction_amount) OVER (PARTITION BY trans.customer_id),
    ROW_NUMBER() OVER (PARTITION BY invoices.customer_id ORDER BY invoices.invoice_id)
FROM invoices as invoices
JOIN CustomerTransactions as trans
ON invoices.invoice_id = trans.invoice_id
WHERE invoice_date < '2007-12-01'
