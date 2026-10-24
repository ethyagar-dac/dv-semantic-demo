-- Satellite on a LINK (not a hub): attributes of an order line, with history.
--
-- TODO: same pattern as sat_order.sql. Parent key = order_line_hk.
-- Attributes: quantity, extended_price, discount, return_flag, ship_date.
--
-- Interview question: why are quantity and price on a link satellite and not
-- on sat_order or sat_part?

select 1 as todo_remove_me
