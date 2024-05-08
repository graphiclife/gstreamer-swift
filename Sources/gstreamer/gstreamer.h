#include <glib.h>
#include <glib-object.h>

#include <gst/gst.h>

#ifndef GSTREAMER_SWIFT_EXPORT_TYPES
#define GSTREAMER_SWIFT_EXPORT_TYPES
static const GType G_TYPE_W_INVALID = G_TYPE_INVALID;
static const GType G_TYPE_W_NONE = G_TYPE_NONE;
static const GType G_TYPE_W_INTERFACE = G_TYPE_INTERFACE;
static const GType G_TYPE_W_CHAR = G_TYPE_CHAR;
static const GType G_TYPE_W_UCHAR = G_TYPE_UCHAR;
static const GType G_TYPE_W_BOOLEAN = G_TYPE_BOOLEAN;
static const GType G_TYPE_W_INT = G_TYPE_INT;
static const GType G_TYPE_W_UINT = G_TYPE_UINT;
static const GType G_TYPE_W_LONG = G_TYPE_LONG;
static const GType G_TYPE_W_ULONG = G_TYPE_ULONG;
static const GType G_TYPE_W_INT64 = G_TYPE_INT64;
static const GType G_TYPE_W_UINT64 = G_TYPE_UINT64;
static const GType G_TYPE_W_ENUM = G_TYPE_ENUM;
static const GType G_TYPE_W_FLAGS = G_TYPE_FLAGS;
static const GType G_TYPE_W_FLOAT = G_TYPE_FLOAT;
static const GType G_TYPE_W_DOUBLE = G_TYPE_DOUBLE;
static const GType G_TYPE_W_STRING = G_TYPE_STRING;
static const GType G_TYPE_W_POINTER = G_TYPE_POINTER;
static const GType G_TYPE_W_BOXED = G_TYPE_BOXED;
static const GType G_TYPE_W_PARAM = G_TYPE_PARAM;
static const GType G_TYPE_W_OBJECT = G_TYPE_OBJECT;

static inline GObjectClass *g_object_w_get_class(GObject *obj) {
    return G_OBJECT_GET_CLASS(obj);
}

static inline GType g_type_w_get_from_class(GObjectClass *klass) {
    return G_TYPE_FROM_CLASS(klass);
}

static inline const GstObject *gst_message_src(GstMessage *message) {
    return GST_MESSAGE_SRC(message);
}

static const GSourceFunc gst_bus_w_async_signal_func = (GSourceFunc) gst_bus_async_signal_func;

static inline GstPadProbeType gst_pad_probe_info_type(GstPadProbeInfo *info) {
    return GST_PAD_PROBE_INFO_TYPE(info);
}

static inline gpointer gst_pad_probe_info_data(GstPadProbeInfo *info) {
    return GST_PAD_PROBE_INFO_DATA(info);
}

#endif


